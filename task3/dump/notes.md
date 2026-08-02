# FINN Folding Optimization Journal — tfc-w1a1 MNIST MLP

## 0. The model

`tfc-w1a1.onnx` is a small binarized-weight MLP for MNIST:

```
input (28x28 image) -> Reshape/flatten -> Thresholding (input quant)
  -> FC1 (784->64) -> FC2 (64->64) -> FC3 (64->64) -> FC4 (64->10) -> LabelSelect (argmax)
```

In FINN's HW graph these show up as `Reshape_rtl_0`, `Thresholding_rtl_0`,
`MVAU_hls_0..3`, `LabelSelect_hls_0`. Confirmed by reverse-engineering
dimensions from the auto-folding cycle counts: FINN's per-layer cycle
estimate is roughly

```
cycles ≈ (MW / SIMD) × (MH / PE)
```

where MW = fan-in, MH = fan-out (neurons). Solving this against the
auto-fold numbers gave MW×MH pairs of 784×64, 64×64, 64×64, 64×10 — i.e.
784 → 64 → 64 → 64 → 10.

## 1. Baseline: automatic folding

```json
"Reshape_rtl_0": 784, "Thresholding_rtl_0": 784,
"MVAU_hls_0": 896, "MVAU_hls_1": 512, "MVAU_hls_2": 512, "MVAU_hls_3": 640,
"LabelSelect_hls_0": 10
```

- `estimated_throughput_fps`: 111,607 (from `max_cycles` = 896, the MVAU_hls_0 layer)
- `stable_throughput[images/s]` (actual rtlsim): **30,534** — nearly 4x lower than the estimate
- Resources: LUT 8220, BRAM_18K 4, BRAM_36K 3, DSP 0

**Concept — two different "throughput" numbers:**
`estimated_throughput_fps` = `fclk / max_cycles`, where `max_cycles` is
the single worst layer's cycle count, assuming perfect, fully-overlapped
pipelining with zero overhead. It's a theoretical ceiling.
`stable_throughput[images/s]` comes from actual RTL simulation and
includes real FIFO/handshake/pipeline-fill behavior across the *whole*
chain. These will diverge, and the gap tends to widen as folding gets
more aggressive (see §6). Rule of thumb going forward: **trust rtlsim
numbers, treat the estimate report as a rough upper bound only.**

## 2. First folding attempts — chasing the MVAU layers

Manually pushed PE/SIMD up on the four `MVAU_hls_*` layers (leaving
`Reshape_rtl_0`/`Thresholding_rtl_0` at PE=1). One fold synthesized
successfully, one failed. Comparing them: the failed fold pushed
PE×SIMD (roughly proportional to instantiated LUT-based MAC units,
since `resType: lut` → zero DSPs, everything in fabric logic) about
**6.8x higher** than the passed fold in one jump, including two layers
at `PE=SIMD=MW=MH` (i.e. fully unrolled, no folding left at all).
That combination of extreme parallelism + LUT-only multiplication is a
classic way to blow LUT budget / fail timing closure.

**Lesson:** when bisecting between a known-good and known-bad fold,
don't push every layer to the max simultaneously — increase PE and
SIMD as separate, moderate steps, and preferably reuse whichever axis
already has a proven-safe value.

But regardless of how hard the MVAUs were folded, **`Reshape_rtl_0`
stayed pinned at 784 cycles** in every attempt, capping throughput at
`100MHz / 784 ≈ 127,551 fps` no matter what. This became the real
target.

## 3. Chasing the Reshape_rtl_0 bottleneck — a wrong turn first

Tried setting `Reshape_rtl_0` PE directly to 112 in the folding config.
FINN's build crashed at `step_set_fifo_depths`:

```
AssertionError: PE must divide last axis
  finn/custom_op/fpgadataflow/reshape.py:87
  assert num_elems % self.pe == 0
```

**My first (wrong) theory:** I assumed FINN stores image tensors
channels-last (NHWC), like its CIFAR examples (`(1,32,32,3)`), and
guessed the "last axis" for MNIST would therefore be the channel
count = 1 — meaning `Reshape_rtl_0`'s PE would be permanently locked
to 1, un-fixable via folding_config, and would require restructuring
the ONNX graph itself (removing the Reshape node, feeding a
pre-flattened `[1,784]` tensor as the model's literal input).

**The actual answer:** this particular model's input tensor is
`[1, 1, 28, 28]` — **NCHW**, not NHWC. The "last axis" `Reshape_rtl_0`
folds over is **W = 28**, not the channel count. So `28 % PE == 0`
is the real constraint, giving legal PE values of **{1, 2, 4, 7, 14, 28}**
— a much less restrictive limit than I'd assumed, and *no ONNX surgery
required* to get meaningful parallelism here.

**Lesson (the important one):** don't reason about "the last axis"
generically from a remembered convention — check the actual tensor
shape for the actual node in the actual graph:

```python
from qonnx.core.modelwrapper import ModelWrapper
model = ModelWrapper("FINN_TMP/<intermediate step>.onnx")
node = model.get_nodes_by_op_type("Reshape")[0]
print(model.get_tensor_shape(node.input[0]))
```

A wrong assumption about data layout led to a much more invasive
"fix" than was actually necessary. Cheap to verify, expensive to
guess wrong.

## 4. Custom Fold 1 — PE=28 on Reshape and Thresholding

With the corrected constraint understood, set `Reshape_rtl_0` and
`Thresholding_rtl_0` PE to 28 (the max legal divisor of 28), on top
of already-folded MVAU layers.

```json
"Reshape_rtl_0": 28, "Thresholding_rtl_0": 28,
"MVAU_hls_0": 14, "MVAU_hls_1": 4, "MVAU_hls_2": 4, "MVAU_hls_3": 2,
"LabelSelect_hls_0": 2
```

- `estimated_throughput_fps`: 3,571,428
- `stable_throughput[images/s]`: **1,265,823** (≈2.8x below estimate)
- LUT 26,790 (+3.3x vs baseline), BRAM_36K **79** (+26x vs baseline!),
  FF 45,725, SRL 3,383, DSP still 0

**Concept — why Reshape and Thresholding cycle counts differ (784→28)
by the exact same math:**
`Reshape_rtl_0` works on the pre-flatten 4D tensor `(N,C,H,W)`; its
cycle formula is really `H × (W/PE)` = `28 × (28/28)` = 28.
`Thresholding_rtl_0` works on the *already-flattened* 784-element
vector (Reshape's output), so its constraint is `784 % PE == 0`
directly — `784/28 = 28` cycles. Same PE value, same numeric result
here, but for structurally different reasons — worth not conflating.

**New observation:** `Reshape_rtl_0` and `Thresholding_rtl_0` are
still the joint bottleneck at 28 cycles, ahead of MVAU_hls_0's 14.
Also: BRAM_36K jumping from 3 to 79 is a real resource flag —
depending on the target device's total BRAM_36K budget (e.g. a
Zynq-7020 has 140), a small MLP alone eating over half the chip's
BRAM is worth watching before it stacks with FIFOs/IODMA in the
final post-synth report.

## 5. Custom Fold 2 — flatten the ONNX input itself

Rather than fight the 28-cycle ceiling imposed by the 4D
`(1,1,28,28)` shape, changed the model's input tensor to `[1, 784]`
directly (flattening done at the ONNX level before feeding FINN,
rather than as a HW node).

Effect: **`Reshape_rtl_0` disappears from the graph entirely** — the
"784-cycle problem" is solved by removing its cause, not by folding
around it. `Thresholding_rtl_0` also benefits doubly: it's now
consuming the true 784-wide graph input directly, so its legal PE
range widens from divisors-of-28-derived values up to the full
**divisors of 784** — including 112, which wasn't reachable before.

```json
"Thresholding_rtl_0": 7,
"MVAU_hls_0": 14, "MVAU_hls_1": 4, "MVAU_hls_2": 4, "MVAU_hls_3": 2,
"LabelSelect_hls_0": 2
```
(`Thresholding_rtl_0` PE=112 → `784/112 = 7` cycles.)

- `estimated_throughput_fps`: 7,142,857
- `stable_throughput[images/s]`: **1,818,182**
- LUT 27,893, BRAM_36K 79 (unchanged), FF 47,655, SRL 3,578

New bottleneck: `MVAU_hls_0` at 14 cycles.

**Note for future-self:** flattening the input shape at the ONNX
level (rather than trying to graph-surgery the Reshape node out
manually, which was my original overcomplicated suggestion) turned
out to be the simple, correct move. Worth double-checking downstream
that pixel ordering in the flattened `[1,784]` input matches what the
FC layer's weight matrix expects — a flatten is a relabeling, not
computation, but get the element order wrong and you get wrong
predictions at full speed, which is a nastier bug than a slow
accelerator.

## 6. Custom Fold 3 — closing the gap on MVAU_hls_0

Increased `MVAU_hls_0` PE from 32 to 64, halving its cycle count from
14 to 7 — now tied with `Thresholding_rtl_0` as the shared bottleneck.

```json
"Thresholding_rtl_0": 7,
"MVAU_hls_0": 7, "MVAU_hls_1": 4, "MVAU_hls_2": 4, "MVAU_hls_3": 2,
"LabelSelect_hls_0": 2
```

- `estimated_throughput_fps`: 14,285,714 (exactly 2x fold 2, as expected — max_cycles halved)
- `stable_throughput[images/s]`: **1,923,077** — only **+5.8%** over fold 2

**This gap is the most useful data point in the whole exercise.**
Backing out the *real* interval length from each measured throughput
(`cycles = fclk / stable_throughput`, since `fclk` = 100MHz throughout):

| Fold | max_cycles (estimate) | real interval (derived from rtlsim fps) |
|---|---|---|
| auto | 896 | 3275 |
| custom 1 | 28 | 79 |
| custom 2 | 14 | 55 |
| custom 3 | 7 | 52 |

Estimated `max_cycles` halved from fold 2 to fold 3 (14→7), and the
*estimated* fps doubled accordingly — but the *real* interval only
dropped from 55 to 52 cycles (~5.8%). In other words: fixing the
layer the estimate report *told me* was the bottleneck stopped
helping almost immediately, because the true, rtlsim-measured
bottleneck by that point was something the per-layer `max_cycles`
metric doesn't capture at all — likely fixed pipeline-fill/FIFO
handshake overhead spread across the whole chain, not attributable
to any single layer's II. This is exactly the estimate-vs-rtlsim gap
flagged in §1, just much sharper once cycle counts get small: a
27-cycle round-trip that used to be background noise against 896
cycles becomes >80% of the total once the "advertised" bottleneck
shrinks to 7.

**Practical implication:** past a certain point, chasing the
`estimate_layer_cycles.json` bottleneck stops being the highest-value
thing to optimize. Squeezing further real throughput would need
actually locating the *rtlsim*-level bottleneck (FIFO stall analysis,
per-node rtlsim tracing) rather than continuing to shrink whichever
layer currently has the largest number in the estimate report.

## 7. Resource cost — the trade-off nobody should skip

Across the three custom folds, resource usage tracks parallelism
aggressively — and not just in the dimension being tuned:

| Metric | auto | custom 1 | custom 2 | custom 3 |
|---|---|---|---|---|
| LUT | 8,220 | 26,790 | 27,893 | 37469 |
| FF | 11,045 | 45,725 | 47,655 | 65356 |
| SRL | 436 | 3,383 | 3,578 | 5372 |
| BRAM_36K | 3 | 79 | 79 | 129 |
| BRAM_18K | 4 | 3 | 3 | 3 |
| DSP | 0 | 0 | 0 | 0 |

`DSP` staying at 0 throughout is expected and intentional —
`resType: "lut"` forces all multiply-accumulate logic into fabric
LUTs instead of DSP slices, which is why LUT/FF/SRL scale so sharply
with PE×SIMD while DSP count never moves. If LUT budget or timing
closure becomes the limiter in post-synth results, switching the
biggest layer(s) to `resType: "dsp"` is the natural next lever to
pull — trading LUT/routing pressure for DSP slices, an axis
completely orthogonal to folding.

**TODO — post-synthesis results (custom 3):**
```
"LUT": 37469,
"SRL": 5372,
"FF": 65356,
"BRAM_36K": 129,
"BRAM_18K": 3,
"DSP": 0
```

## 8. Glossary (for future me)

- **PE (Processing Elements):** folding factor over the *output*
  dimension (neurons / channels). Higher PE = more output neurons
  computed in parallel per cycle = fewer cycles, more replicated logic.
- **SIMD:** folding factor over the *input* dimension (fan-in /
  channels). Higher SIMD = wider per-cycle dot-product, same
  cycle/resource trade-off from the other axis.
- **"PE/SIMD must divide MH/MW":** the hard legality constraint —
  MH (output size) % PE == 0, MW (input size) % SIMD == 0. Violating
  it is a hard `AssertionError`, not a soft warning.
- **"Last axis" for non-MVAU nodes (Reshape, Thresholding, LabelSelect):**
  each node's fold constraint is checked against *that specific
  node's own current tensor shape* at that point in the graph —
  which depends on data layout (NCHW vs NHWC) and where in the graph
  you are (pre- or post-flatten). Never assume; check
  `model.get_tensor_shape(...)` directly.
- **`max_cycles` vs real rtlsim interval:** `max_cycles` (and the
  `estimated_throughput_fps` derived from it) is the single worst
  layer's isolated cycle count, assuming ideal pipelining.
  `stable_throughput[images/s]` from rtlsim is the actual measured
  steady-state rate including FIFO/handshake overhead across the
  whole design — the two increasingly diverge as folding gets
  aggressive (§6).
- **`resType: lut` vs `dsp`:** which physical resource implements the
  MAC — LUT fabric logic vs dedicated DSP slices. LUT-based scales
  logic usage fast under heavy folding; DSP-based trades that for a
  separate, often more constrained resource pool.
- **`WMEM` (implicit):** weight memory depth = `(MW×MH)/(PE×SIMD)`;
  needs to work out to an integer, which divisibility of PE/SIMD
  against MW/MH already guarantees.

## 9. Key takeaways

1. A single un-folded node upstream (Reshape stuck at PE=1) can cap
   *the entire pipeline's* throughput regardless of how hard you fold
   everything downstream — always check every node in the estimate
   report, not just the "big" compute layers.
2. When a folding assert blocks you, don't reason about the fix from
   a remembered convention (NHWC-vs-NCHW, etc.) — go check the actual
   tensor shape in the actual intermediate model. A wrong assumption
   here led to a much more invasive proposed fix (full ONNX graph
   surgery) than the real, simple one (flatten the declared input
   shape) needed.
3. Sometimes the cleanest fix for a HW-node folding limit isn't
   folding around it at all — it's restructuring the ONNX graph so
   the limiting node doesn't need to exist (custom fold 2).
4. Bisect folding aggressiveness one axis/layer at a time where
   possible; pushing every layer to its max simultaneously is how you
   get the kind of resource blowup that fails synthesis outright.
5. Trust `stable_throughput` / rtlsim over `estimated_throughput_fps`
   — and expect the gap between them to *grow*, not shrink, as your
   fold gets more aggressive. Past a certain point, the
   `estimate_layer_cycles.json` bottleneck stops being where the real
   bottleneck lives.
6. Resource usage (LUT, FF, SRL, BRAM) scales with folding
   aggressiveness across the *whole* design, not just the layer being
   tuned — watch BRAM_36K/LUT against the target device's real budget
   before assuming a fold that "estimates well" will actually
   synthesize and close timing.

---
# FINN & FPGA Acceleration: Technical Reference & Deep Dive

---

## 1. Board Capabilities & Platform Hardware Differences

When deploying neural networks to FPGAs using FINN, hardware targets determine the upper bounds for logic unrolling, memory capacity, and streaming interfaces:

* **PYNQ-Z2 / PYNQ-Z1 Target Boards:**
  * **FPGA Fabric:** AMD/Xilinx Zynq-7000 SoC (XC7Z020-1CLG400C).
  * **Clock Frequency ($f_{\text{clk}}$):** Typically configured at **100.0 MHz** (10 ns clock period) for default FINN dataflow overlays.
  * **Resource Constraints:** Contains fixed counts of Look-Up Tables (LUTs ~53,200), Flip-Flops (FFs ~106,400), Block RAM (BRAM ~140 blocks / 4.9 Mb), and DSP Slices (DSP48E1 ~220).
  * **I/O Limitations:** Uses an AXI4-Stream interface over a Zynq PS-PL (Processing System to Programmable Logic) DMA channel (`FINNDMAOverlay`). Because the input stream is configured to transfer 1 byte/cycle (e.g., for UINT8 MNIST pixels), sequential input streaming is bound by total input dimensions (e.g., $28 \times 28 = 784$ clock cycles minimum per image).

---

## 2. FINN Build Configurations, Pipeline Steps, & Output Artifacts

FINN converts high-level ONNX/QONNX neural network models into stitched IP dataflow pipelines via a multi-step compilation process controlled by `build.yaml`.

### Key Pipeline Stages (20-Step Compilation):
1. **`step_qonnx_to_finn` & `step_tidy_up`:** Standardizes node representations, attributes, and shapes.
2. **`step_streamline`:** Collapses redundant layers (e.g., merging batch norm into thresholds, floating-point scaling into integer/bipolar ops).
3. **`step_convert_to_hw` & `step_specialize_layers`:** Converts abstract ONNX operations into FINN FPGA Dataflow HLS/RTL custom operations (`MVAU_hls`, `Thresholding_rtl`, etc.).
4. **`step_target_fps_parallelization` / `step_apply_folding_config`:** Calculates or applies layer-wise `PE` and `SIMD` factors.
5. **`step_minimize_bit_width`:** Shrinks accumulator and weight bit-widths to lower resource footprint.
6. **`step_generate_estimate_reports`:** Generates analytical theoretical reports based on cycle bottlenecks.
7. **`step_set_fifo_depths`:** Determines inter-layer FIFO depths to prevent pipeline backpressure or deadlocks.
8. **`step_hw_codegen` & `step_hw_ipgen`:** Generates C++/Vivado HLS code and synthesizes individual IP blocks for each layer.
9. **`step_create_stitched_ip`:** Connects all layer IPs sequentially using AXI-Stream interfaces into a full system overlay.
10. **`step_measure_rtlsim_performance`:** Executes cycle-accurate PyRTL / Vivado XSI simulation on test vectors.
11. **`step_out_of_context_synthesis` & `step_synthesize_bitfile`:** Runs Vivado synthesis and place-and-route to produce the final FPGA bitstream (`.bit`) and hardware handoff file (`.hwh`).
12. **`step_make_driver` & `step_deployment_package`:** Generates Python PYNQ drivers and configuration dictionaries (`settings.json`).

### Essential Output Reports & Directory Structure:
* **`FINN_TMP/`:** Holds intermediate ONNX models at every transformation step (e.g., `step_target_fps_parallelization.onnx` for Netron inspection).
* **`output_auto/report/estimate_network_performance.json`:** Analytical FPS and latency projections.
* **`output_auto/report/rtlsim_performance.json`:** Cycle-accurate simulation statistics.
* **`output_auto/bitfile/`:** Final hardware bitstream files (renamed to `tfc_w1a1_auto.bit` and `tfc_w1a1_auto.hwh` for board deployment).
* **`output_auto/driver/settings.json`:** Defines I/O shapes (`ishape_normal`, `ishape_folded`, `ishape_packed`), input/output data types (`UINT8`, `INT2`, etc.), and DMA IP instance names (`idma0`, `odma0`).

---

## 3. Mathematical Mechanics: How Folding Factors Dictate Clock Cycles

A FINN Matrix-Vector Activation Unit (`MVAU`) computes matrix multiplications ($Y = W \cdot X$) using two primary parallelization parameters:

* **`PE` (Processing Elements):** Parallelizes across **outputs (neurons)**.
* **`SIMD` (Single Instruction, Multiple Data):** Parallelizes across **inputs (synapses)** within each PE.

### Layer Compute Cycle Equation:
$$\text{Cycles per Layer} = \left( \frac{\text{Num Output Neurons}}{\text{PE}} \right) \times \left( \frac{\text{Num Inputs}}{\text{SIMD}} \right)$$

### Example (`TFC-W1A1` Layer 0: 784 Inputs $\rightarrow$ 64 Neurons):
1. **Conservative Folding ($\text{PE} = 2$, $\text{SIMD} = 28$):**
   $$\text{Cycles} = \left(\frac{64}{2}\right) \times \left(\frac{784}{28}\right) = 32 \times 28 = 896 \text{ clock cycles}$$
2. **Aggressive Folding ($\text{PE} = 64$, $\text{SIMD} = 56$):**
   $$\text{Cycles} = \left(\frac{64}{64}\right) \times \left(\frac{784}{56}\right) = 1 \times 14 = 14 \text{ clock cycles}$$

---

## 4. Automatic vs. Manual Folding

| Feature / Trait | Automatic Folding (`target_fps`) | Manual Folding (`folding_config_file`) |
| :--- | :--- | :--- |
| **Configuration Method** | User specifies `target_fps` in `build.yaml`. | User specifies a path to a JSON file explicitly assigning `PE` & `SIMD` per layer. |
| **Heuristic Strategy** | FINN runs an internal greedy algorithm to calculate minimal `PE` and `SIMD` factors to meet the target FPS. | User inspects intermediate ONNX dimensions in Netron and manually tunes divisors to push resource limits. |
| **Resource Efficiency** | Conservative; often overestimates resource demands and leaves significant FPGA fabric idle. | Highly aggressive; maximizes LUT/DSP utilization right up to synthesis failure. |
| **Best Used For** | Rapid prototyping, initial baseline verification, and meeting modest throughput targets. | Maximizing hardware performance, minimizing latency, and squeezing peak FPS out of a specific board. |

---

## 5. Analytical Estimate vs. RTL Simulation Throughput

### Why does RTL simulation report ~30,534 FPS while analytical estimation reports ~111,607 FPS (in auto mode)?

1. **Analytical Estimate (`estimate_network_performance.json`):**
   * **Assumes Steady-State Streaming ($N \rightarrow \infty$):** Calculates throughput based purely on the **slowest single layer** in the pipeline (the bottleneck node, `max_cycles = 896`).
   * **Formula:**  
     $$\text{Estimated FPS} = \frac{f_{\text{clk}}}{\text{max\_cycles}} = \frac{100\text{ MHz}}{896} \approx 111,607 \text{ FPS}$$
   * Ignores interface serialization, initial AXI handshakes, and input/output transfer overheads.

2. **RTL Simulation (`rtlsim_performance.json`):**
   * **Measures Real Frame Boundaries ($N = 1$):** Simulates a single image transaction from start to finish, including the time required to push 784 individual input bytes over the single AXI-Stream interface (`N_IN_TXNS: 784`).
   * **Transaction Overhead:** For a single image, the total pipeline interval (`interval_cycles`) was **3,273 cycles**.
   * **Formula:**  
     $$\text{Simulated FPS} = \frac{f_{\text{clk}}}{\text{interval\_cycles}} = \frac{100\text{ MHz}}{3,273} \approx 30,534 \text{ FPS}$$
   * **Key Takeaway:** If a batch of continuous frames ($N \gg 1$) were streamed sequentially into the RTL simulation, the pipeline would fill up and average throughput would scale up toward the theoretical 111.6k limit.

---

## 6. Bottleneck Shifting & Performance Evolution

As manual parallelization factors increase across `MVAU` layers, the bottleneck shifts from neural network computation to physical bus streaming:

[Baseline Auto Config]
Compute Bottleneck: MVAU_hls_0 (896 cycles)
└─> Latency: ~32.75 µs | Throughput: ~30,534 FPS

│  (Increase PE & SIMD on MVAU layers)
    ▼
    
    
    [Aggressive Manual Config]
Compute Time Collapses: MVAU_hls_0 drops from 896 cycles -> 14 cycles!
Interface Bottleneck: Reshape_rtl_0 (784 cycles)
└─> Latency: ~8.19 µs (4x improvement!) | Throughput: ~122,100 FPS (Bound by 784-byte AXI stream)











# FINN FPGA Accelerator Optimization & Manual Folding: Lessons Learned

## 1. General Concepts & Core Mechanics

### Neural Network Folding on FPGAs
Folding is the process of mapping a neural network’s computational graph onto physical FPGA hardware by trading **spatial parallelism (logic/DSP resources)** for **time (clock cycles)**.

* **Fully Unrolled (Maximum Parallelism):** Instantiates dedicated hardware units for every single operation. Blazing fast (1 cycle per layer), but quickly exceeds physical FPGA resources (LUTs/DSPs).
* **Fully Serial (Minimum Hardware):** Executes operations sequentially through a single compute unit. Minimal hardware usage, but high latency and low throughput (FPS).
* **Folding (Balanced Mapping):** Tunes hardware resource usage to achieve a desired performance point (throughput and latency) within target device resource constraints.

### Key Hardware Parameters (PE vs. SIMD)
* **PE (Processing Elements):** Controls **neuron (output feature)** parallelism. Determines how many output channels of a layer are calculated simultaneously.
* **SIMD (Single Instruction, Multiple Data):** Controls **synaptic (input feature)** parallelism. Determines how many input connections per neuron are processed in parallel within each PE.
* **Compute Cycle Formula:**
  $$\text{Cycles per Layer} = \left( \frac{\text{Num Output Neurons}}{\text{PE}} \right) \times \left( \frac{\text{Num Inputs}}{\text{SIMD}} \right)$$

---

## 2. Constraints & Trade-Offs

1. **Divisibility Rule:**  
   `PE` must cleanly divide the layer's output dimension, and `SIMD` must cleanly divide the layer's input dimension. Selecting a non-integer divisor causes compiler transformation assertions to fail.
2. **Input Stream Bottleneck vs. Compute Throughput:**  
   * Analytical estimations (`estimate_network_performance.json`) evaluate theoretical continuous dataflow assuming infinite pipeline bandwidth.
   * Real-world I/O throughput (`rtlsim_performance.json`) is bound by interface constraints (e.g., AXI-Stream width). If the input stream transfers data sequentially (e.g., $28 \times 28 = 784$ single-byte transactions), the input stream node (e.g., `Reshape_rtl_0`) sets the hard floor on minimum cycles, regardless of how fast downstream compute layers run.
3. **Analytical vs. RTL Simulation Metrics:**  
   * **Estimated Throughput:** Calculates peak throughput based purely on the bottleneck layer's compute cycle limit:  
     $$\text{Estimated FPS} = \frac{f_{\text{clk}}}{\text{max\_cycles}}$$
   * **RTL Simulation Throughput:** Measures actual cycle-accurate transaction timings for finite sample batches ($N$), incorporating AXI handshake delays and serialization overhead.

---

## 3. Problems Encountered & Applied Solutions

### Problem 1: Invalid Parameter Divisibility Error
* **Symptom:**  
  `AssertionError: Requirement NumChannels divisable by PE is violated.` during `step_minimize_bit_width`.
* **Root Cause:**  
  Attempting to scale `PE > 1` on single-channel non-matrix layers (such as `Thresholding_rtl_0` or `Reshape_rtl_0`), where the number of input/output channels is 1.
* **Solution:**  
  Restricted `PE` and `SIMD` scaling exclusively to layers with compatible tensor dimensions (e.g., `MVAU_hls` matrix-vector nodes), maintaining `PE = 1` for 1D input streaming and thresholding nodes.

---

### Problem 2: Vivado HLS Synthesis Failure (Out of Hardware Resources)
* **Symptom:**  
  `ERROR: HLS IP Generation failed` at `step_set_fifo_depths` / `step_hw_ipgen`.
* **Root Cause:**  
  Over-parallelizing early matrix layers (e.g., setting `PE = 64` and `SIMD = 392` or `196` on `MVAU_hls_0`). Instantiating tens of thousands of parallel multiply-accumulate units in a single HLS block exceeded routing capacity and physical LUT/DSP limits on the target Zynq FPGA.
* **Solution:**  
  Systematically stepped down `SIMD` on the failing node to valid lower divisors (e.g., from `392` $\rightarrow$ `196` $\rightarrow$ `56`), isolating the highest functional parallelization factor right below the synthesis threshold.

---

### Problem 3: Process Hanging on Background HLS Errors
* **Symptom:**  
  FINN reported a non-zero exit code due to an HLS subprocess failure, but background Python worker threads remained active and hung in the background.
* **Root Cause:**  
  Multi-worker synthesis pipelines (`NUM_WORKERS > 1`) sometimes fail to gracefully terminate all child processes when an individual sub-task crashes.
* **Solution:**  
  Identified hanging PIDs via `ps aux | grep finn` and force-killed the main parent process (`kill -9 <PID>`) to purge lingering worker threads before relaunching `finn build`.

---

### Problem 4: Estimated Throughput Plateauing Despite Layer Acceleration
* **Symptom:**  
  Scaling `PE` and `SIMD` across `MVAU` nodes reduced critical path latency but left `estimated_throughput_fps` stuck at ~127,551 FPS.
* **Root Cause:**  
  `Reshape_rtl_0` remained the pipeline bottleneck at 784 cycles ($100\text{ MHz} / 784 \approx 127.5\text{k FPS}$), as it processes 1-byte AXI stream pixels sequentially.
* **Solution / Verification:**  
  Inspected `rtlsim_performance.json` to confirm real compute gains: latency dropped from **3,274 cycles (~32.75 µs)** down to **818 cycles (~8.19 µs)**, quadrupling actual simulated frame throughput to **~122.1k FPS** by collapsing downstream matrix execution times down to near-instantaneous cycle counts (~34 cycles).

---

## 4. Optimized Configuration Reference (`TFC-W1A1`)

```json
{
  "Defaults": {},
  "Reshape_rtl_0": { "PE": 1 },
  "Thresholding_rtl_0": {
    "PE": 1,
    "runtime_writeable_weights": 0,
    "depth_trigger_uram": 0,
    "depth_trigger_bram": 0
  },
  "MVAU_hls_0": {
    "PE": 64,
    "SIMD": 56,
    "ram_style": "auto",
    "ram_style_thresholds": "auto",
    "resType": "lut",
    "mem_mode": "internal_decoupled",
    "runtime_writeable_weights": 0
  },
  "MVAU_hls_1": {
    "PE": 64,
    "SIMD": 64,
    "ram_style": "auto",
    "ram_style_thresholds": "auto",
    "resType": "lut",
    "mem_mode": "internal_decoupled",
    "runtime_writeable_weights": 0
  },
  "MVAU_hls_2": {
    "PE": 64,
    "SIMD": 64,
    "ram_style": "auto",
    "ram_style_thresholds": "auto",
    "resType": "lut",
    "mem_mode": "internal_decoupled",
    "runtime_writeable_weights": 0
  },
  "MVAU_hls_3": {
    "PE": 10,
    "SIMD": 64,
    "ram_style": "auto",
    "ram_style_thresholds": "auto",
    "resType": "lut",
    "mem_mode": "internal_decoupled",

"runtime_writeable_weights": 0
  },
  "LabelSelect_hls_0": { "PE": 10 }
}
```
---

# FINN Compiler: Target FPS vs. Custom Folding Configuration

## Overview
In the Xilinx/AMD FINN framework for FPGA AI acceleration, defining both `target_fps` and `folding_config_file` in the build configuration is **not problematic**, and the custom folding configuration is **not ignored**.

## How FINN Resolves the Conflict
The compiler resolves the interaction between `target_fps` and a custom folding file through the execution sequence of its build steps:

1. **`step_target_fps_parallelization` (First):** 
   - The compiler calculates the required parallelization attributes (PE and SIMD values) based on the `target_fps` target and annotates the internal graph.
2. **`step_apply_folding_config` (Second):** 
   - The compiler reads the provided custom folding JSON file. PE and SIMD attributes specified in the custom file explicitly **overwrite** any automatic parallelization attributes generated during the target FPS step.

## Build Implications
* **Resulting Hardware:** The generated IP, stitched dataflow, and final bitfile reflect the settings defined in the custom folding JSON file.
* **Performance Impact:** Leaving `target_fps` uncommented results in slightly longer build times because the compiler runs automatic solver calculations that are subsequently overwritten. 

## Lab Recommendation
Lab instructions typically advise commenting out `target_fps` when using a custom folding file solely to prevent redundant calculations and speed up the compilation workflow. If a build has already been executed with both enabled, the custom folding parameters were still correctly applied.

---
- connect the board according to the steps in the task pdf
- run the following command to find the board IP address (it should be starting with 10.42)
bash
arp -a

- open the jupyter notebook in your browser at:

http://10.42.0.154

(If prompted for a password or token, the default PYNQ password is usually xilinx).

- upload the zipfile fpgannlab.zip onto the board
- open a terminal on the web server
- open the file test_mnist.py and run all cells, check accuracy, it should be a reasonable value (e.g. 90%+)

- The cell outputs were:
%%%%%%%%%%%%%%%%%%%%%%%%%
Downloading bitstream took 1.2247557640075684 seconds

Looking for Train Imgs
Tar File found in data_dir. Not Downloading again
Looking for Train Labels
Tar File found in data_dir. Not Downloading again
Looking for Test Imgs
Tar File found in data_dir. Not Downloading again
Looking for Test Labels
Tar File found in data_dir. Not Downloading again
batch 1 / 10 : total OK 913 NOK 87
batch 2 / 10 : total OK 1800 NOK 200
batch 3 / 10 : total OK 2714 NOK 286
batch 4 / 10 : total OK 3619 NOK 381
batch 5 / 10 : total OK 4535 NOK 465
batch 6 / 10 : total OK 5488 NOK 512
batch 7 / 10 : total OK 6438 NOK 562
batch 8 / 10 : total OK 7399 NOK 601
batch 9 / 10 : total OK 8371 NOK 629
batch 10 / 10 : total OK 9296 NOK 704
Inference of whole test set took: 0.093456 seconds
Final accuracy: 92.960000
%%%%%%%%%%%%%%%%%%%%%%%%%


- Add Vivado to PATH
source /Software/xilinx/Vivado/2023.2/settings64.sh

- Make sure the relevant conda environment is active

- On your local machine, run (yes run it twice):
bash
finn deps update
finn deps update


- run the FINN build pipeline: (FINN runs hardware synthesis via Vivado in Docker)
bash
finn build build.yaml


this will take some time


You can analyze performance metrics, target FPS, resource utilization, and check synthesis/out-of-resources logs using estimate_network_performance and rtlsim_performance. 

### estimate_network_performance.json output
^^^
{
  "critical_path_cycles": 4138,
  "max_cycles": 896,
  "max_cycles_node_name": "MVAU_hls_0",
  "estimated_throughput_fps": 111607.14285714286,
  "estimated_latency_ns": 41380.0
}
^^^

From that we can observe that MVAU_hls_0 is the bottleneck


### rtlsim_performance.json output
^^^
{
  "N_IN_TXNS": 784,
  "N_OUT_TXNS": 1,
  "cycles": 3275,
  "N": 1,
  "latency_cycles": 3274,
  "interval_cycles": 3273,
  "TIMEOUT": 0,
  "UNFINISHED_INS": 0,
  "UNFINISHED_OUTS": 0,
  "RUNTIME_S": 0,
  "runtime[ms]": 0.03275,
  "throughput[images/s]": 30534.351145038167,
  "fclk[mhz]": 100.0,
  "stable_throughput[images/s]": 30534.351145038167
}
^^^

It is expected for RTL simulation throughput (~30.5k FPS) to be lower than the analytical estimation (~111.6k FPS).

The simple estimate assumes continuous streaming with perfect back-to-back pipelining without interface overheads. The RTL simulation (rtlsim_performance) measures actual cycle-accurate transaction timings, including the handshake overhead (AXI-Stream) for transferring input data (784 byte transactions for MNIST) and output results over the interface bus


You will only need access to a physical PYNQ-Z2 board later to flash the .bit file and run the final accuracy check in Jupyter.  




The goal in Section 3.3 is to repeatedly increase the PE and SIMD values to maximize parallelization until the synthesis fails because the FPGA's physical resources (LUTs, BRAM, or DSPs) are completely maxed out.


^^^^^



Folding is the process of mapping a neural network’s large, multi-layer computational graph onto a fixed, finite amount of FPGA hardware resources by trading off spatial parallelism for time (cycles)

To understand folding, consider the two extreme ways to implement a Neural Network layer on an FPGA:Fully Unrolled (Maximum Parallelism / High Resource Usage):If a fully connected layer has 64 neurons and each neuron takes 784 inputs, a fully unrolled implementation instantiates dedicated multiplier-accumulator (MAC) hardware units for all $64 \times 784 = 50,176$ operations.Result: Blazing fast (1 clock cycle per layer), but it quickly exhausts the FPGA's physical Logic (LUTs) and DSP slices.  


Fully Folded / Serial (Minimum Resource Usage / Slow Execution):You instantiate a single physical multiplier hardware unit and run all 50,176 operations sequentially through it over 50,176 clock cycles.Result: Minimal FPGA hardware footprint, but high latency and low throughput (FPS).  




A boot jumper is a small plastic connector containing a metallic strip that bridges two pins on a circuit board to select where the Zynq SoC loads its boot software/OS from (e.g., SD card, onboard QSPI flash memory, or JTAG).  



On the PYNQ-Z2, setting it to the SD card position ensures the board loads the PYNQ Linux image from the inserted Micro SD card upon powering on.  

How to Set it to SD Card Mode
Locate the Jumper Header (JP1):
Look at the top edge of the board near the Ethernet port and Micro SD slot. You will see a 4-pin row labeled Boot with options typically marked as SD, QSPI, and JTAG.  

Identify the SD Pins:
The SD label corresponds to the two leftmost pins of that 4-pin header.

Move the Shunt:
Gently pull off the small black plastic shunt (jumper clip) and push it down over the two leftmost pins (marked SD).

Quick Visual Check:

    Boot Jumper (JP1): Placed on the SD position (leftmost 2 pins).

    Power Jumper (JP2 / REG/USB): Set to USB (if powering via micro-USB cable).




how to flash an SD card for zynq board

^^^^^


All user files, notebooks, and work are stored directly on the Micro SD card, NOT on the board itself.

The PYNQ-Z2 board itself has non-volatile memory (like QSPI flash), but when the boot jumper is set to SD mode, the Zynq SoC uses the SD card as its main storage disk (holding both the PetaLinux OS and the root filesystem). The board's volatile RAM resets completely every time you power it off




In this context, FPS stands for Frames Per Second (or inferences per second).  
It measures the throughput of your neural network accelerator—specifically, how many input samples (images) the FPGA can process through the neural network in one second.  

