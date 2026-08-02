A QuantTensor is a custom Brevitas object that bundles your data with its quantization metadata (scale, bit-width, zero-point). 
It does not natively support standard PyTorch tensor operations like .argmax() directly on the wrapper object.
 
When the (forward pass) of the model outputs a QuantTensor, then to get the output, we need to explicitly access the `value` attribute



# FINN + Brevitas + GTSRB Project — Lessons Learned & Troubleshooting Notes

## Project Context

**Goal:** Train a quantized CNN in Brevitas, export it to QONNX, and compile it with FINN for deployment on a PYNQ-Z2 FPGA while maximizing throughput (FPS) and maintaining at least **90% classification accuracy**.

Target toolchain:

```text
PyTorch (Brevitas)
      ↓
export_qonnx
      ↓
QONNX
      ↓
FINN transformations
      ↓
FINN hardware layers
      ↓
RTL generation
      ↓
Bitstream
```

---

# 1. MaxPool vs TruncAvgPool Confusion

## Initial assumption

The original network used

```python
nn.MaxPool2d(...)
```

Later, I was advised to replace it with

```python
qnn.TruncAvgPool2d(...)
```

because FINN has historically had better support for average pooling.

This caused confusion because I was later (incorrectly) advised to use

```python
qnn.QuantMaxPool2d(...)
```

which does **not** exist.

The resulting error was

```text
AttributeError:
module 'brevitas.nn' has no attribute 'QuantMaxPool2d'
```

## Lesson learned

There is **no**

```python
qnn.QuantMaxPool2d
```

layer in Brevitas.

Current practical options are

```python
nn.MaxPool2d
```

or

```python
qnn.TruncAvgPool2d
```

depending on the FINN/Brevitas version and deployment requirements.

Never assume that every PyTorch layer has a quantized Brevitas equivalent.

Always verify available layers using

```python
dir(brevitas.nn)
```

or the official documentation.

---

# 2. TruncIntQuant Import Error

Attempted solution:

```python
from brevitas.quant.solver import TruncIntQuant
```

Result:

```text
ImportError:
cannot import name 'TruncIntQuant'
```

## Cause

The Brevitas API changes across versions.

Many online examples and GitHub repositories target older releases.

## Lesson learned

Always verify APIs against the installed Brevitas version rather than copying code from tutorials.

Useful commands:

```python
import brevitas.quant

dir(brevitas.quant)
help(...)
```

---

# 3. Trunc Node Rounding Mode

After exporting with `qnn.TruncAvgPool2d`, the ONNX graph contained `Trunc` nodes.

Some advice suggested manually adding

```text
rounding_mode = FLOOR
```

However, inspection showed that the exported graph already contained

```text
rounding_mode = round
```

Therefore, the attempted patch accomplished nothing.

## Lesson learned

Always inspect the exported ONNX graph before modifying it.

Example:

```python
from qonnx.core.modelwrapper import ModelWrapper

m = ModelWrapper("model.onnx")

for node in m.graph.node:
    print(node)
```

Never patch ONNX graphs blindly.

---

# 4. FINN Internal Compiler Error

Main compiler error:

```text
ValueError:
max() arg is an empty sequence
```

during

```text
step_target_fps_parallelization
```

Stack trace ended in

```python
critical_path_cycles = max(latency_at_node_output.values())
```

## What this means

FINN computed

```python
latency_at_node_output = {}
```

which means that **no hardware dataflow nodes existed** after conversion.

Therefore, the folding algorithm itself is **not** the root cause.

The actual failure occurred earlier in the transformation pipeline.

## Lesson learned

This error is almost always a symptom rather than the underlying cause.

When encountering this exception, investigate earlier transformation stages rather than focusing on the folding pass.

---

# 5. Empty FINN_TMP Directory

Even after enabling

```yaml
save_intermediate_models: True
```

the `FINN_TMP` directory remained empty.

## Lesson learned

If FINN aborts before intermediate models are written, `FINN_TMP` may legitimately remain empty.

Do not rely on the directory contents to determine how far the build progressed.

Instead, inspect the build log carefully.

---

# 6. Build YAML Confusion

My assignment required a custom preprocessing step:

```yaml
steps:
  - step_qonnx_to_finn
  - transform_input.step_transform_input
  - ...
```

A previously working assignment instead used

```yaml
generate_outputs:
  - estimate_reports
  - stitched_ip
```

without explicitly listing build steps.

## Lesson learned

Different FINN versions support different build configuration styles.

Older examples often rely on `generate_outputs`.

Newer workflows explicitly specify every build step.

Avoid mixing configuration styles unless the FINN version is known to support both.

---

# 7. Custom Input Transformation

The assignment required moving preprocessing into hardware.

Pipeline:

```text
Raw UINT8 image
        ↓
Normalization
        ↓
Classifier
        ↓
TopK (Argmax)
```

The custom transformation performs:

1. Export normalization module.
2. Merge preprocessing model.
3. Annotate input as UINT8.
4. Insert TopK.
5. Infer shapes and layouts.

## Lesson learned

The transformation logic itself appeared reasonable.

However, custom preprocessing significantly increases debugging complexity.

Whenever FINN fails, first verify that the plain classifier builds successfully before introducing preprocessing.

---

# 8. BatchNorm

Originally the architecture contained

```text
Conv
↓
QuantReLU
```

Later changed to

```text
Conv
↓
BatchNorm
↓
QuantReLU
```

## Motivation

Low-bit quantization-aware training (especially W2A3/W3A3) is usually much more stable with BatchNorm.

## Important discovery

BatchNorm is effectively **free** in the deployed hardware.

During FINN streamlining,

```text
Conv
↓
BatchNorm
↓
MultiThreshold
```

is transformed into

```text
Conv
↓
MultiThreshold
```

by modifying thresholds.

No dedicated BatchNorm hardware is synthesized.

## Lesson learned

BatchNorm generally improves convergence and accuracy during training while introducing essentially **zero hardware overhead** after successful FINN streamlining.

---

# 9. Proper Model Evaluation

Original workflow:

```text
Train
↓

Validation

↓

Export
```

Improved workflow:

```text
Train
↓

Validation

↓

Best checkpoint

↓

Test

↓

Export
```

## Lesson learned

Validation should be used for model selection.

Testing should evaluate the final selected model.

This avoids overly optimistic performance estimates.

---

# 10. Reproducibility

Added deterministic training:

```python
random.seed(...)
np.random.seed(...)
torch.manual_seed(...)
torch.cuda.manual_seed_all(...)
```

plus

```python
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
```

## Lesson learned

Architecture exploration is difficult to compare without deterministic training.

Always fix random seeds when benchmarking models.

---

# 11. BatchNorm During Export

Before exporting:

```python
model.eval()
```

is called.

## Lesson learned

BatchNorm must be in evaluation mode before export so that running statistics are frozen.

---

# 12. Resume Training

Current implementation restores only

```python
model.state_dict()
```

Optimizer and scheduler states are **not** restored.

## Lesson learned

Loading only weights is not a true training resume.

A complete checkpoint should include:

- model weights
- optimizer state
- scheduler state
- current epoch

---

# 13. DataLoader Improvements

Possible future optimization:

```python
pin_memory=True
persistent_workers=True
```

when training on CUDA.

Small performance improvement with essentially no downside.

---

# 14. Dummy Input for Export

Current export uses

```python
torch.randn(...)
```

For ONNX export, zero tensors or uniformly distributed random values are usually preferable because the dummy input only defines graph shapes and datatypes.

---

# 15. Most Important Debugging Lesson

The most valuable lesson from this debugging session is:

> **Never trust the final compiler error as the root cause.**

FINN reported

```text
ValueError:
max() arg is an empty sequence
```

inside the folding stage.

However, the real issue is much more likely that **the graph reaching the folding stage contains no recognized hardware dataflow nodes**, meaning something failed earlier during graph transformation.

Future debugging should therefore focus on verifying every transformation stage:

- QONNX export
- preprocessing merge
- streamlining
- hardware conversion
- dataflow partition creation

rather than assuming the folding algorithm itself is broken.

---

# Best Practices Going Forward

1. Verify the exported ONNX graph after every architectural change.
2. Keep a minimal baseline model that is known to compile with FINN before introducing preprocessing or other custom transformations.
3. Make one change at a time and rebuild after each change.
4. Inspect intermediate graphs after each FINN transformation whenever possible.
5. Check the installed Brevitas and FINN versions before following tutorials or GitHub examples.
6. Use BatchNorm before quantized activations for low-bit QAT whenever possible; it typically improves convergence without increasing deployed hardware cost.
7. Treat FINN internal compiler exceptions as indicators that an earlier transformation may have failed rather than assuming the reported pass is defective.














# Hardware-Aware Quantization with Brevitas and FINN: Comprehensive Lessons Learned

## 1. Core Architectural Rules for FINN Compilation
When designing a neural network in PyTorch/Brevitas targeted for Xilinx FINN (e.g., PYNQ-Z2 deployment), the architecture must conform to strict hardware-mapping constraints. Standard software ML practices often cause compiler crashes.

* **Data Layout Constraints (NCHW vs. NHWC):** PyTorch operates natively in NCHW (Batch, Channels, Height, Width), but FINN’s FPGA streaming dataflow strictly requires NHWC. FINN attempts to automatically push a `Transpose` node through the ONNX graph during compilation. If this transpose operation gets mathematically blocked (e.g., hitting a 2D flattening node), FINN will silently abort hardware conversion.
* **Bias-Free Hardware is Preferred:** Standard biases on `QuantConv2d` or `QuantLinear` layers require dedicated DSPs or adders on the FPGA. Setting `bias=False` forces FINN to build highly efficient, pure `MatrixVectorActivation` (MVAU) streaming engines, maximizing FPS.
* **Unsigned ReLUs:** A ReLU function, by definition, zeroes out negative numbers and outputs only positive values. FINN strictly enforces that ReLU layers use unsigned quantization (`Uint8ActPerTensorFloat`). Passing a signed quantizer to a ReLU will crash the compiler.
* **Input Preprocessing Bottlenecks:** While normalizing inputs (mean/std subtraction) is standard in PyTorch, it forces inputs into a signed distribution. FPGA cameras and sensors output raw unsigned 8-bit integers (0-255). To avoid severe ARM CPU bottlenecks (processing every pixel before FPGA inference), it is best to remove software normalization, train on raw 0-255 values, and use an unsigned input quantizer.
* **Software Illusion vs. True Hardware Accuracy:** Extraneous quantization layers (like adding `QuantIdentity` after pooling) add hidden learnable scaling factors in PyTorch. While these speed up early-epoch software convergence, they don't map to physical FPGA routing. Removing them causes a temporary accuracy drop but reflects the strict, *true* capability of the hardware.

## 2. The Pooling Dilemma: MaxPool vs. AvgPool
Pooling operations behave very differently in hardware compared to software, dictating strict design choices.

* **The Hardware Cost of Average Pooling:** Software Average Pooling requires division. In FPGA hardware, division is extremely logic-heavy. FINN implements Average Pooling via integer bit-shifting (which inherently rounds down). Therefore, FINN strictly requires an explicit `FLOOR` rounding metadata tag on any `Trunc` node.
* **The Elegance of Max Pooling:** `nn.MaxPool2d` is universally preferred for FINN because it consumes zero arithmetic logic (no DSPs, no adders). It uses simple hardware comparators to route the largest integer. 
* **The `QuantIdentity` Trap:** Older versions of FINN required a `QuantIdentity` layer after `MaxPool2d` to re-attach bit-width metadata. Modern FINN+ (v0.12.1+) inherently understands the `Conv -> MaxPool -> Conv` pattern. Adding a `QuantIdentity` node breaks FINN's topological pattern matching, resulting in an aborted hardware mapping.
* **The "Illusion" of Software Accuracy:** Removing extra `QuantIdentity` layers removes hidden learnable scaling factors, often causing an immediate accuracy drop in early training epochs. This drop simply reflects the rigid physical routing of the FPGA; allowing the network to train for its full epoch count (e.g., 70 epochs with Cosine Annealing) allows it to recover and converge on the "true" hardware accuracy.

## 3. Crucial Code Modifications & PyTorch Tricks
Translating PyTorch models to FINN requires specific forward-pass interventions.

* **The Permute-Before-Flatten Trick:** To solve the NCHW-to-NHWC compiler block, manually permute the spatial dimensions *before* the flatten operation: `x = x.permute(0, 2, 3, 1)`. This allows FINN's automated transpose and your manual transpose to meet and cancel out. Retraining from scratch is mandatory after adding this, as the `QuantLinear` weights must learn the new spatial order.
* **Remove Final Output Quantization:** The final classifier (`fc2`) outputs raw integer logits. Do not append an `out_quant` node. FINN expects a raw `MatMul` output to wrap up the hardware partition.
* **Handling Raw PyTorch Tensors vs. QuantTensors:** Removing `out_quant` means the model's `forward()` pass returns a standard PyTorch `Tensor` rather than a Brevitas `QuantTensor`. Consequently, calls to `.value` (e.g., `out.value.argmax()`) in the training and validation loops must be changed to operate directly on the tensor (e.g., `out.argmax()`).
* **Brevitas String kwargs:** Brevitas 0.12.1 heavily refactored its API, breaking many `FloatToIntImplType` imports. Instead of chasing broken enum imports, pass string definitions directly to the layer (e.g., `float_to_int_impl_type="FLOOR"`).

## 4. FINN Compiler Error Ledger (Problems & Solutions)

### Error: `FINN only supports unsigned and non-narrow Quant nodes for Relu activations.`
* **Cause:** The `QuantReLU` layer was initialized with a signed quantizer (`Int8ActPerTensorFloat`).
* **Solution:** Create an unsigned quantizer class (inheriting from `Uint8ActPerTensorFloat`) and assign it to the `act_quant` parameter of all `QuantReLU` layers.

### Error: `FINN only supports signed Quant nodes for identity activations.`
* **Cause:** FINN's `QuantIdentityHandler` expects identity nodes to be signed. We assigned an unsigned quantizer to a `QuantIdentity` layer placed after a ReLU/MaxPool.
* **Solution:** Delete the `QuantIdentity` layers following `MaxPool2d` entirely. Modern FINN handles standard PyTorch max pooling perfectly without them.

### Error: `The Trunc node must have the rounding_mode set to 'FLOOR'.`
* **Cause:** Brevitas exported a generic truncation node for `TruncAvgPool2d` without guaranteeing the floor operation FINN needs to synthesize a bit-shift hardware block.
* **Solution:** The best path is to replace `qnn.TruncAvgPool2d` with `nn.MaxPool2d`. If average pooling is absolutely required, pass the kwarg `float_to_int_impl_type="FLOOR"` into the layer definition.

### Error: `AttributeError: 'Tensor' object has no attribute 'value'`
* **Cause:** The `forward()` function returned a raw PyTorch tensor because `self.out_quant` was removed for FINN compatibility, but the training script still expected a Brevitas `QuantTensor` wrapper.
* **Solution:** Update the training and validation loops to use `out` directly instead of `out.value`. (e.g., `loss = criterion(out, labels)`).




In a perfectly balanced dataflow architecture, your heaviest compute nodes should be the bottlenecks.

mvau_wwidth_max: 54
a wider weight streamer costs more LUT/BRAM, don't take this arbitrarily high on a 7020


1. Is 76% Utilization Good?For an academic prototype or a competition constraint (like a FINN deployment workflow on a lab board), 76% is excellent. It means you pushed the hardware to extract maximum parallelization without running out of routing resources. However, in a strict commercial setting, 76% is considered uncomfortably close to the ceiling because it leaves very little margin for future updates, ECOs (Engineering Change Orders), or layout congestion.
2. Professional Production-Grade Utilization RangeIn professional FPGA design (aerospace, telecom, high-frequency trading), the golden target ranges are:Logic (LUTs/FFs): 50% to 60% maximum.Memory (BRAM/URAM): 60% to 70%.Why? Staying below 60% logic utilization ensures that Vivado has plenty of routing "highway" available. This guarantees fast place-and-route times, avoids routing congestion, and makes it easy to close timing at high clock frequencies without heroic manual floorplanning constraints.
3. Is Not Using DSPs Good or Bad?In your specific case, it is entirely optimal (and expected) for low-precision binary/ternary neural networks.The Reason: Xilinx DSP48E1 slices are heavy, rigid hardware blocks designed for wide arithmetic (e.g., 25-bit $\times$ 18-bit signed multiplication). Packing a 2-bit weight network into a DSP wastes 90% of its internal multiplier capacity.The Result: Building small 2-bit multiply-accumulate logic out of fabric LUTs is actually more space-efficient and allows massive parallelization (like your MVAUs) that would otherwise be severely bottlenecked if you only relied on the limited count of physical DSP slices on the chip.
4. BRAM_36K vs. BRAM_18K and "140 Equivalents"The Difference: Xilinx 7-series FPGAs are built out of physical 36Kb Block RAM (BRAM_36K) primitives. Each 36Kb block can also be dynamically split into two independent 18Kb blocks (BRAM_18K) if your design requires smaller, shallower FIFOs or memories.






















# Comprehensive Report: Hardware-Aware Quantized Neural Network Design
**Tools:** PyTorch, Brevitas, ONNX, Xilinx FINN
**Target:** Maximizing Figure of Merit (FoM = Accuracy × Throughput) on FPGA (e.g., PYNQ-Z2)

---

## 1. Brevitas & Quantization-Aware Training (QAT)

### The "Zero-Cost" BatchNorm Trick
* **The Problem:** In ultra-low bitwidth Quantization-Aware Training (like W2A3, W3A3, or W4A4), activations can easily saturate or blow up during early training, limiting the network's ability to learn and leading to accuracy degradation.
* **The Solution:** Inject a `nn.BatchNorm2d` layer immediately after the `QuantConv2d` and before the `QuantReLU` in every spatial block.
* **Hardware Implication (The "Trick"):** This adds absolutely zero latency or resource cost to the final hardware. During FINN's streamlining step, the sequence `Conv -> BN -> Threshold` mathematically collapses into `Conv -> Threshold`. The batch normalization parameters are algebraically absorbed into the MultiThreshold node.

### Overfitting vs. Generalization in Small Datasets
* **The Problem:** Reaching high validation accuracy (e.g., 97%+) but suffering a severe drop in held-out test accuracy (e.g., < 91%).
* **The Solution:** Aggressive data augmentation (random rotations, brightness/contrast shifts, affine scaling). With ultra-quantized models, the network tends to memorize pixel layouts rather than features. Augmentation forces the learning of invariant features, closing the generalization gap.

---

## 2. Network Topology: Accuracy vs. Throughput

### Topology Reduction vs. Precision Reduction
* **Core Concept:** Multiply-Accumulate (MAC) operations in convolutional layers scale proportionally to `C_in × C_out × K^2`.
* **Throughput Optimization:** Reducing the channel dimensions (e.g., from `[16, 32, 64]` to `[8, 16, 32]`) drastically cuts down the topology. This is often far more effective for maximizing throughput than dropping precision (e.g., moving from W2A3 to W2A2). 
* **Why it Works:** While dropping precision saves a marginal amount of Look-Up Tables (LUTs) per individual operation, reducing channels removes thousands of operations entirely. This frees up massive amounts of FPGA resources (LUTs and BRAMs), which FINN can then use to unroll the remaining operations for extreme parallelism.

---

## 3. FINN, PE/SIMD, and Hardware Unrolling

### Forcing FINN's Auto-Folding (The FPGA "Blank Check")
* **Concept:** FINN determines how much to parallelize a network (using Processing Elements (PE) and SIMD lanes) based on the `target_fps` defined in the build configuration.
* **The Problem:** Setting a modest `target_fps` (e.g., 100,000) might leave a huge portion of the FPGA resources (like 65% of LUTs and 85% of BRAM) completely unused.
* **The Solution:** Set an impossible `target_fps` (e.g., 400,000 or 1,000,000). This acts as a blank check, forcing FINN's `step_target_fps_parallelization` to aggressively unroll the bottleneck layers (like the Matrix-Vector Activation Units `MVAU` and `ConvolutionInputGenerator`) until it runs out of FPGA resources. This drops the `max_cycles` per layer, drastically spiking throughput.

### HLS Estimates vs. Vivado Reality
* **Concept:** High-Level Synthesis (HLS) reports (`estimate_layer_resources_hls.json`) give a pessimistic estimate of hardware usage.
* **Observation:** An HLS estimate might predict 86,000+ LUTs on a board that physically only possesses ~53,200 LUTs. 
* **Conclusion:** Vivado's downstream logic optimizer (`step_synthesize_bitfile`) is highly efficient at packing, trimming, and sharing logic. Do not blindly abort a build based on an oversized HLS estimate; let Vivado attempt synthesis first.

---

## 4. Hardware Metrics & Simulation Reality

### Understanding the Throughput Discrepancy
When evaluating FINN reports, you will encounter two very different throughput metrics:

1. **`estimated_throughput_fps` (from `estimate_network_performance.json`)**
   * **What it is:** The theoretical, absolute ceiling of the pipeline (e.g., ~215k FPS).
   * **Calculation:** `Clock Frequency / max_cycles` (the heaviest bottleneck layer).
   * **Flaw:** It assumes a utopian hardware environment with perfect zero-latency transitions, ignoring all data routing overhead.

2. **`throughput[images/s]` (from `rtlsim_performance.json`)**
   * **What it is:** The realistic, ground-truth speed (e.g., ~67k FPS).
   * **Calculation:** Verilator simulation of the actual compiled Verilog code processing real image data over a cycle-accurate timeframe.
   * **Why it matters:** This accounts for real-world hardware physics—FIFO queues filling up and stalling, pipeline backpressure, and the multi-cycle AXI-Stream `TVALID`/`TREADY` handshakes required to move data. This is the only metric that dictates actual physical performance.

---

## 5. Advanced Hardware Tricks

### "Free" Speed via Overclocking
* **The Concept:** Throughput scales linearly with clock frequency.
* **The Trick:** The default synthesis clock in FINN is typically 100 MHz (`synth_clk_period_ns: 10.0`). Because ultra-thin, low-bit networks (like W2A3) have very short, shallow combinatorial logic paths, Vivado can typically route them successfully at much higher frequencies.
* **Execution:** Drop the period to `8.0` ns (125 MHz) or `7.5` ns (133 MHz). If it passes timing constraints during synthesis, this yields an instant, pure mathematical multiplier (25% to 33% boost) to the final throughput without sacrificing a single drop of accuracy.








Why dataset normalization ≠ BatchNorm
These two operations look similar on paper, but they operate on different axes, at different times, and for different purposes.

1. Dataset normalization (your NormPreprocessing)
Applied once, at input, before the network.

Uses fixed constants: dataset mean/std.

Ensures pixel values are in a stable range.

Makes the input distribution match what the network was trained on.

Required for deployment, especially when streaming raw UINT8 pixels.

2. BatchNorm (inside your model)
Applied inside the network, after convolutions.

Uses learned γ/β parameters.

Normalizes feature maps, not raw pixels.

Stabilizes training, improves gradient flow.

Has nothing to do with raw pixel scaling.

These two normalizations operate on different tensors:

Dataset normalization → raw pixels
BatchNorm → intermediate feature maps
They are not interchangeable.



---
## How to compute usage of different models on HW
On throughput, if you're choosing between these two anyway

8-16-32 @ W2A3 is very likely the better throughput candidate on a Zynq-7020, for compute-volume reasons that outweigh the one-bit activation difference:

Rough MAC counts (12×12 input, two poolings since img_size<16 skips pool3):

Model	conv1+conv2+conv3 MACs	FC MACs	Total MACs
8-16-32, W2A3	~114k	~21k	~135k
12-24-36, W2A2	~210k	~23k	~233k

The wider model has ~1.7x the total MACs. Weighting by bit-cost (weight×activation bits per MAC — a reasonable proxy for LUT/DSP cost per multiply-accumulate on 7-series FPGAs, which don't get the low-bit DSP-packing tricks of newer Versal/UltraScale+ parts):

8-16-32 @ W2A3: 135k × 6 ≈ 811k bit-ops
12-24-36 @ W2A2: 233k × 4 ≈ 934k bit-ops

Even after crediting the narrower activation, the bigger model needs more total hardware resource on a fixed-size chip (PYNQ-Z2's xc7z020 only has 106 DSP48E1s and ~53,200 LUTs — a small budget). More resource-per-inference means less headroom for SetFolding to increase PE/SIMD parallelism within that fixed budget, which is what buys you FPS. So the narrower channel model should let FINN fold more aggressively and hit a higher throughput ceiling, even though it "spends" one more activation bit per MAC.

There's a secondary effect worth knowing about too: dropping to A2 also shrinks accumulator growth less than you'd think helps, because fc1's input width in the 12-24-36 case is larger (324 vs 288) — wider accumulators cost more LUTs per MVAU regardless of activation bit-width.

Don't take my arithmetic as final — get FINN's actual numbers

This is an estimate from raw MAC counts; it doesn't capture things like Thresholding cost, ConvolutionInputGenerator buffering (which scales with feature map size, identical for both since input is 12×12 for both), or DSP packing efficiency FINN's cost model already knows about. The right move is to run both through step_generate_estimate_reports (cheap — no synthesis needed) and compare estimated_throughput_fps and per-node cycle counts directly from the report JSON before committing either one to a full bitfile build. That'll settle it definitively rather than by hand-estimation.


---
# transform_input.py
MergeONNXModels(prep_model_wrapper) usage — correct. The constructor arg is the model to prepend, so model = model.transform(MergeONNXModels(prep_model_wrapper)) correctly puts your normalization graph in front of the classifier, with the merged graph's new global input becoming the raw-pixel input. This is the right call signature and the right variable to reassign.
UINT8 annotation — correctly grabs model.graph.input[0].name after the merge (so it's pointing at the preprocessing module's raw input, not the old classifier input), and set_tensor_datatype is the right QONNX API for this. Note this only sets FINN's semantic datatype annotation, not the ONNX tensor's proto element type (which stays float32) — that's expected and is exactly how FINN expects it; step_streamline and later step_qonnx_to_finn-derived thresholding read this annotation to determine hardware bit-width, not the proto dtype.
Step ordering (merge → set dtype → InsertTopK → InferShapes/InferDataLayouts) — this matches the canonical order used in FINN's own end-to-end example notebooks. InsertTopK only needs valid shape info on the classifier's original output tensor (untouched by the merge, since the merge only rewrites the input side), so running it before the final shape/layout cleanup pass is fine, not a bug.
Placement in the steps list — transform_input.step_transform_input immediately after step_qonnx_to_finn, before step_tidy_up/step_streamline — correct per the spec, and functionally necessary: the normalization Div/Sub/Div chain needs to land in front of the already-FINN-converted first MultiThreshold so step_streamline can algebraically absorb it into that layer's thresholds, which is what the task's hint about "automatically absorb... into the thresholds" depends on.


---
# One optional (not required) architecture nit

conv1/conv2/conv3 don't set bias=False, so they default to a learned bias — immediately followed by BatchNorm2d, whose own learned shift (beta) makes the conv bias redundant (BN re-centers the output regardless of what the conv's bias was). It's not wrong — it'll still train and export fine, FINN's streamlining can fold Conv+bias+BN together — but it's an unnecessary extra parameter per channel with no benefit once BN is added. If you want the conventional cleanup:

python
self.conv1 = qnn.QuantConv2d(3, c1, kernel_size=3, padding=1, bias=False,
                              weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)

(same for conv2, conv3). Purely optional — I wouldn't rerun a completed training job just for this, only apply it on your next fresh run if convenient.

---
# The Folding Story of GTSRB Dataflow Tuning — A Case Study in FINN Resource Tuning

_A narrative account of two models' folding-configuration journeys: lessons first learned on the smaller `12x12_w2a3_c8x16x32` model, then carried forward and applied more efficiently to `12x12_w2a3_c12x24x36`. Kept as a worked example of the reasoning process, not just the conclusions._

---

## PROLOGUE — Lessons Learned on `12x12_w2a3_c8x16x32`

_Before the `c12x24x36` model was ever tuned, its channel-narrower sibling `c8x16x32` (conv channels 8→16→32, vs. 12→24→36) went through its own investigation. The lessons discovered here — about unreachable targets, false bottlenecks, simulation pitfalls, and hidden resource caps — are what made the later `c12x24x36` tuning (Chapters 4 onward) faster and more targeted. Worth keeping as the "how we learned to read FINN's reports" origin story, even though the specific numbers below belong to the smaller model, not the one the rest of this report focuses on._

### The Mystery of the Identical Builds

The investigation started with something that looked broken: three separate builds of `c8x16x32`, targeting `target_fps` of 400,000, 800,000, and 1,200,000, all came back with **the exact same `auto_folding_config.json` and the exact same measured performance (~67k fps)**. Three wildly different requests, one identical answer.

The diagnosis came from doing the arithmetic FINN itself does internally:
target_cycles_per_frame = fclk_MHz × 1e6 / target_fps

At a 100 MHz clock:

| target_fps | required cycles/frame |
|---|---|
| 400,000 | 250 |
| 800,000 | 125 |
| 1,200,000 | 83 |

The model, at that point, was running at **1,491 cycles/frame** (≈67k fps) — 6 to 18 times slower than any of the three targets demanded. **All three targets were simultaneously unreachable.** `SetFolding`'s greedy per-layer algorithm keeps unfolding (raising PE/SIMD) node by node until it either hits the target or runs out of room it's willing to spend — and since none of the three requested targets were attainable at all, the algorithm ran to the exact same practical ceiling every time and stopped there, regardless of which impossible number it had been asked to hit.

**Lesson:** before trusting a `target_fps`, always sanity-check it against `fclk / target_fps` versus your current cycles/frame. If every target you throw at auto-folding produces the same config, that's not FINN being lazy — it's a sign every target so far has been out of reach, and auto-folding has already found its own ceiling.

### Chasing the Wrong Bottleneck (and Correcting Course)

The first hypothesis for "where's the real ceiling" was built purely from the **divisibility constraints table** (`MH % PE == 0`, `MW % SIMD == 0`), cross-referenced against `c8x16x32`'s actual layer dimensions:

| Node | MH (out) | MW (in) | Current PE/SIMD | Room to grow? |
|---|---|---|---|---|
| MVAU_hls_0 (conv1) | 8 | 27 | PE=8, SIMD=9 | PE maxed; SIMD could → 27 |
| MVAU_hls_1 (conv2) | 16 | 72 | PE=8, SIMD=18 | PE → 16; SIMD → 24/36/72 |
| MVAU_hls_2 (conv3) | 32 | 144 | PE=8, SIMD=18 | PE → 16/32; SIMD → many options |
| MVAU_hls_3 (fc1) | 64 | 288 | PE=4, SIMD=18 | PE → 8/16/32/64 |
| MVAU_hls_4 (fc2) | 43 | 64 | PE=1, SIMD=8 | **PE can only be 1 or 43 — 43 is prime** |
| LabelSelect_hls_0 | 43 | — | PE=1 | same prime-43 constraint |

That last row looked, on paper, like the obvious villain: GTSRB has 43 classes, 43 is prime, and the constraint table's rule for `LabelSelect`/`Thresholding` leaves **no intermediate parallelism option** at all — it's PE=1 (serial) or PE=43 (fully parallel), nothing in between. The natural conclusion was that this serial final stage was capping the whole pipeline, and the fix proposed was to force the jump straight to PE=43.

Then the actual per-node cycle data came in, and it told a completely different story:
ConvolutionInputGenerator_rtl_3: 463 ← highest single node
Thresholding_rtl_0: 432 ← tied second
MVAU_hls_0: 432 ← tied second
...
LabelSelect_hls_0: 43 ← trivial
**`LabelSelect_hls_0` only cost 43 cycles.** It was never the bottleneck at all — it was one of the cheapest nodes in the entire network. The divisor-table reasoning had correctly identified a *real structural constraint*, but incorrectly assumed that constraint implied it was *the* bottleneck. It wasn't. The real offenders were an RTL window generator and a thresholding node, nowhere near the prime-43 stage.

**Lesson, the important one:** a divisibility constraint tells you where a node's *ceiling* is — it says nothing about whether that node is currently *limiting* anything. Always check the actual `estimate_layer_cycles.json` values before deciding which constraint matters. A node that's "stuck" at a low PE/SIMD isn't a problem unless it's also expensive in raw cycles relative to everything else.

There was also a side-quest here worth remembering: at that same moment, the `rtlsim_performance.json` showed `"N": 1`, and `latency_cycles` (1490) was suspiciously almost identical to `interval_cycles` (1489) — a red flag that only one image had been simulated, meaning no pipeline overlap had been observed and the "true" steady-state throughput was still unknown. That thread got set aside temporarily (folding decisions are made from analytical estimates, before rtlsim ever runs, so it doesn't affect folding choices — only the *measurement* of the result afterward) but it's a companion lesson: **don't trust a single-image rtlsim number as your throughput figure.**

### Finding the Real Ceiling: A Silent Resource Cap

With attention now correctly on the actual high-cycle nodes, a pattern emerged that explained *why* several of the MVAU layers were all stuck at the exact same SIMD value regardless of their different MW:

`MVAU_hls_1`, `MVAU_hls_2`, and `MVAU_hls_3` were all sitting at **SIMD=18** — not because 18 happened to be each one's individual legal maximum, but because of a hidden, global constraint: `mvau_wwidth_max` (default value **36**), which caps an MVAU's per-cycle weight-stream width via roughly `SIMD × weight_bits ≤ mvau_wwidth_max`. At 2-bit weights (`W2`), that caps SIMD at exactly 18 — `18 × 2 = 36`. Every MVAU independently topped out at the same number because they were all hitting the *same wall*, not because that was each one's structural ceiling.

Meanwhile, several **other** nodes were sitting far below their legal maximum with no such cap justifying it — and these turned out to be the pipeline's actual worst offenders:

| Node | Cycles | Current | Legal max | Headroom |
|---|---|---|---|---|
| ConvolutionInputGenerator_rtl_3 | **463** (worst of all 17) | SIMD=2 | 16 | 8x |
| Thresholding_rtl_0 | 432 (tied 2nd) | PE=1 | 3 | 3x |
| FMPadding_rtl_2 | 400 | SIMD=1 | 16 | 16x |
| ConvolutionInputGenerator_rtl_1 | 376 | SIMD=4 | 8 | 2x |
| ConvolutionInputGenerator_rtl_4 | 376 | SIMD=4 | 16 | 4x |
| MVAU_hls_4 (fc2) | 344 | SIMD=8 | 16 (under the wwidth cap) | 2x |

**Lesson:** two different phenomena can both leave a node "under-folded" — a real resource cap (like `mvau_wwidth_max`), or simply unclaimed headroom that auto-folding never bothered to take. Telling them apart matters: raising a resource cap costs more silicon per unit of speed; claiming free headroom on an under-utilized RTL node is often nearly free.

_This is where the `c8x16x32` prologue ends and attention shifted to `c12x24x36`. The lessons above — check target reachability first, verify bottlenecks against real cycle data rather than constraint tables alone, watch for silent resource caps vs. genuine free headroom, and never trust N=1 rtlsim numbers — carried forward directly into the work below._

---

## Chapter 4 — The First Manual Config for `c12x24x36`: Moderate, Divisor-Respecting Steps

`c12x24x36` (conv channels 12→24→36) enters the story already at a `36% LUT / 14% BRAM` utilization on its default auto-folding config. Rather than repeat the "identical builds" investigation from scratch, the lessons from the prologue were applied directly: check real cycle data, respect actual divisors, and avoid forcing disproportionate jumps.

The first hand-built folding config avoided two traps deliberately:

- **No forced jumps to a node's absolute legal maximum** where that maximum was disproportionately large relative to the current value (e.g. `MVAU_hls_1`'s PE=12 sitting just below its only next legal option of 24 — a full doubling — was left untouched rather than forced).
- **Every single move checked against actual MH/MW divisors** before being proposed, not just "pick a round number."

The moves made:

| Node | Basis | Before → After | Reasoning |
|---|---|---|---|
| Thresholding_rtl_0 | MH=3 | PE 1→3 | Only 3 channels — full parallelism is cheap here |
| ConvolutionInputGenerator_rtl_1 | ch=12 | SIMD 4→6 | Divisor of 12, roughly midway to max (12) |
| Pool_hls_0 | ch=12 | PE 4→6 | Matched to the SWG above to avoid a width mismatch |
| FMPadding_rtl_1 | ch=12 | SIMD 2→6 | Divisor of 12, consistent with the stage |
| ConvolutionInputGenerator_rtl_3 | ch=24 | SIMD 2→8 | Divisor of 24, roughly a third of max (24) |
| Pool_hls_1 | ch=24 | PE 2→8 | Matched to the SWG feeding it |
| FMPadding_rtl_2 | ch=24 | SIMD 2→8 | Consistent with the pool2 stage width |
| ConvolutionInputGenerator_rtl_4 | ch=24 | SIMD 6→12 | Divisor of 24, doubled — moderate, not max |
| MVAU_hls_2 (conv3) | MH=36 | PE 9→12 | Divisor of 36, moderate step (max would be 36) |
| MVAU_hls_3 (fc1) | MH=64 | PE 4→8 | Divisor of 64, doubled — moderate (max would be 64) |
| MVAU_hls_4 (fc2) | MW=64, weight-width-capped | SIMD 8→16 | Next legal SIMD value under the wwidth ceiling (36-bit cap ÷ 2-bit weights = SIMD≤18; 16 is the highest divisor of MW=64 at or below that) — actually the max reachable value here |

**This config ran through `step_generate_estimate_reports` and reached ~36% LUT utilization and ~14% BRAM utilization.** A meaningful improvement, with real resource headroom still left on the table. That headroom is what set up the next chapter.

**Lesson:** "moderate" folding isn't about picking numbers that feel conservative — it's about respecting each node's actual legal divisor set and matching feeding/fed nodes to each other (e.g. an SWG and the Pool stage right after it) to avoid unnecessary width mismatches (which cost extra DataWidthConverter logic later). A config built this way is *predictable*: you know in advance roughly what it'll cost and what it'll buy.

---

## Chapter 5 — A Second Opinion, and Learning to Actually Check It

At 36% LUT with real headroom remaining, a second, more aggressive folding config was solicited from another LLM. Rather than accept or reject it on the framing alone, it was checked against the same hard rules used throughout:

**The constraint math held up completely.** Every proposed PE/SIMD change was re-verified by hand against `MH % PE == 0` / `MW % SIMD == 0` for `c12x24x36`'s real dimensions (conv1 MH=12/MW=27, conv2 MH=24/MW=108, conv3 MH=36/MW=216, fc1 MH=64/MW=324, fc2 MH=43/MW=64):

| Node | Proposed | Divides cleanly? |
|---|---|---|
| MVAU_hls_0 SIMD=27 | 27 % 27 = 0 ✓ (fully unrolled) |
| MVAU_hls_1 PE=24 | 24 % 24 = 0 ✓ (fully unrolled) |
| MVAU_hls_2 PE=18 | 36 % 18 = 0 ✓ |
| MVAU_hls_3 PE=16 | 64 % 16 = 0 ✓ |
| MVAU_hls_4 SIMD=32 | 64 % 32 = 0 ✓ |

All legal. The accompanying `mvau_wwidth_max: 72` recommendation was also verified as internally consistent rather than arbitrary: `MVAU_hls_0` at SIMD=27, W2 → `27×2=54` bits; `MVAU_hls_4` at SIMD=32 → `32×2=64` bits. Both need a cap ≥64; 72 covers both with a little margin. Correct, not fabricated.

**One claim, though, didn't hold up to full scrutiny — not invalid, just overstated.** The second config added `parallel_window: 1` to `ConvolutionInputGenerator_rtl_2` at `SIMD=12=channels`, framed as "shattering" a 343-cycle wall. This is indeed the documented, legal `SIMD=C, parallel_window=1, M=1` configuration — it would not crash. But the downstream `MVAU_hls_1` consuming that node's output was left at `SIMD=18`, unchanged — meaning the newly-widened window output and the unchanged-width MVAU input would mismatch, silently patched by an auto-inserted DataWidthConverter (a real, expected step in the pipeline) rather than by a clean, full-width handoff. The real cycle reduction on that branch was therefore likely to be **smaller than claimed**, and it would carry a small extra LUT cost for the converter that the original framing didn't mention.

**The genuinely risky part wasn't validity — it was the size of the jump.** Going from a config at 36% LUT to one stacking *several* 2–4x multipliers simultaneously (`MVAU_hls_0` SIMD 9→27 = 3x, `MVAU_hls_1` PE 12→24 = 2x, `MVAU_hls_2` PE 9→18 = 2x, `MVAU_hls_4` SIMD 8→32 = 4x, and `MVAU_hls_3` PE 4→16 = 4x, on the network's single largest layer) risked overshooting the LUT budget in one blind jump rather than a controlled step. The mitigation applied: dial `MVAU_hls_3` back to a 2x jump (PE 4→8) instead of the proposed 4x (PE 4→16), keeping everything else from the second opinion intact.

**Lesson:** a second opinion (human or AI) is worth actually verifying against the hard rules, not just trusting or dismissing wholesale. In this case the core math was sound — the value of the review wasn't catching an error, it was catching an *overstated benefit claim* and an *unnecessarily large single step*, either of which is a more common failure mode than outright invalid configs.

---

## Chapter 6 — Running It, and the 74.4% Reality Check

The adjusted aggressive config was run through `step_generate_estimate_reports`. Results:

- **Estimated throughput: 462,963 fps** — a huge jump from the moderate config's earlier state, and from the original 67k fps baseline (`c8x16x32`'s number, carried over as the starting-point reference).
- **Total LUT: 39,580 / 53,200 available ≈ 74.4%.**
- **Total BRAM (18K blocks): 78 / 280 ≈ 27.9%.**
- **DSP: 0 / 220 — completely unused.**

74.4% LUT triggered real concern, for a specific, structural reason rather than just "that number looks high": **this figure is a pre-synthesis analytical estimate**, and several real costs hadn't been accounted for yet at that pipeline stage:

- **FIFOs between pipeline stages** — `step_set_fifo_depths` hadn't run yet. With 17 nodes needing balanced buffering, and the auto-sizing method defaulting to an RTL-simulation-based approach that tends to size generously, this is not a negligible addition.
- **The DataWidthConverter** likely to be auto-inserted at the `ConvolutionInputGenerator_rtl_2` → `MVAU_hls_1` boundary, from the width mismatch flagged in Chapter 5 — `step_insert_dwc` hadn't run yet either.
- **Zynq shell/DMA/AXI interconnect overhead** from the board's `shell_flow_type` — data-movement infrastructure entirely outside the per-layer dataflow estimate.

**The conclusion drawn: treat 74% as a floor, not a ceiling.** Real post-place-and-route usage was expected to land meaningfully higher once all three of the above landed — with real risk of ending up in the 85–100%+ range, risking a failed fit or brutal congestion-driven place & route.

Two more findings came out of scrutinizing this same report:

- **A LUT hotspot that turned out not to be wasteful.** `MVAU_hls_0` alone accounted for 18,172 LUT — **45.9% of the entire budget** — on what looked like the smallest, earliest layer. Investigating why revealed that this layer's two dimensions constrain two different parameters: **`MH=12` (output channels) constrains PE**, and **`MW=27` (input channels × 3×3 kernel = 3×9) constrains SIMD**. PE=12 had already been maxed out (full divisor of MH=12) in an earlier step. The SIMD side was the one actually changing here: `MW=27 = 3³`, meaning its only legal SIMD divisors are `{1, 3, 9, 27}` — there is no legal value between "3x folded" (SIMD=9 → 432 cycles) and "fully unrolled" (SIMD=27 → 144 cycles). Since the pipeline's bottleneck sat at 216 cycles, no cheaper SIMD choice existed that kept this node under that bottleneck — full unroll on the SIMD side was *forced*, not chosen wastefully. Sparse divisors on the MW dimension can make "full unroll" the only viable SIMD option even when the resulting node looks disproportionately expensive.
- **A genuine, separate inefficiency.** BRAM efficiency per MVAU was dismal — 0.195% for `MVAU_hls_0`, 1.2% for `MVAU_hls_1`, 4.7% for `MVAU_hls_2`. `internal_decoupled` mode allocates weight memory in whole 18Kb-block granularity regardless of how few bits are actually needed, and these weight arrays were tiny. This was noted as low-priority though — since LUT (not BRAM) was the binding constraint, and the fix (`mem_mode: "internal_embedded"`) trades BRAM for *more* LUT, it wouldn't have helped the actual bottleneck.
- **An unexplored, low-risk idea:** all 220 DSP48E1 slices sitting completely idle (`DSP: 0`) while LUT was under real pressure. Trying `resType: "dsp"` specifically on the single biggest LUT consumer (`MVAU_hls_0`) was flagged as worth experimenting with — potentially inefficient at 2-bit precision (a DSP handling one low-bit MAC wastes most of its native width), but with DSPs at 0% and LUT near 75%, even an imperfect trade could buy real headroom.

**Lesson:** always mentally (or literally) tag which stage of the pipeline a resource number comes from. An "estimate" LUT total from before FIFOs/DWCs/shell integration is not the same claim as a post-synthesis LUT total — treating the former as a hard ceiling rather than a floor is how designs quietly grow past their budget by the time they reach real synthesis. Also: when a layer has two dimensions (MH and MW), always be explicit about which parameter (PE or SIMD) each one constrains — conflating them is an easy mistake to make when discussing "the divisors of this layer" informally.

---

## Chapter 7 — The Free Win: Recovering LUT With Zero Throughput Cost

The final move in `c12x24x36`'s story didn't chase more speed at all — it looked for **waste**, using the same estimate report.

The pipeline's critical path was **216 cycles**, jointly set by `MVAU_hls_1` and `MVAU_hls_2` (both tied — neither could be reduced without slowing the whole design, so both were correctly left untouched). But two *other* MVAUs were sitting well below that bottleneck, meaning they were spending real LUT to run faster than the pipeline could ever benefit from:

| Node | Current setting | Cycles | Slack vs. the 216-cycle bottleneck |
|---|---|---|---|
| MVAU_hls_3 | PE=16 | 72 | **144 cycles of unused headroom** |
| MVAU_hls_4 | SIMD=32 | 86 | **130 cycles of unused headroom** |

Since neither node was anywhere near limiting the pipeline, both were pulled back to a still-legal, still-comfortably-under-216 setting:

- **`MVAU_hls_3`**: MH=64, and 8 is a legal divisor. PE 16→8 doubles its cycle count to 144 — still comfortably under 216. Expected to recover roughly half its LUT cost (~2,600 LUT), since MVAU LUT cost scales close to linearly with PE.
- **`MVAU_hls_4`**: MW=64, and 16 is a legal divisor. SIMD 32→16 doubles its cycles to ~172 — still under 216. Bonus: `16 × 2 bits = 32` stays under even the *default* 36-bit `mvau_wwidth_max`, meaning this particular node no longer even needed the raised cap.

**Net effect: identical estimated throughput (216-cycle bottleneck, ~462,963 fps unchanged), for meaningfully less LUT** — a pure efficiency gain with zero cost, simply from recognizing that not every node needs to be as fast as it can be, only as fast as the *slowest* node in the pipeline.

**Lesson, and the throughline of the whole story:** in a pipelined dataflow accelerator, throughput is set entirely by the single slowest stage. Every cycle of speed on a non-bottleneck node is resources spent for nothing. The right question is never "can this node go faster?" — it's "is this node currently the reason the whole design is slow?" Answering that correctly, and re-answering it after every change (since the bottleneck moves), was the actual method underlying every productive step across both models in this investigation.
---
# The Folding Story of `12x12_w2a3_c8x16x32` — A Case Study in FINN Resource Tuning

_A complete, standalone narrative of this model's folding journey — from an unreachable target_fps mystery, through a false-bottleneck correction, to a real-post-synthesis-calibrated aggressive push, a discovered MVAU floor, a parallel_window breakthrough borrowed from a sibling model, and finally a genuine architectural spatial limit. Kept as a full worked example for future reference._

---

## Chapter 1 — The Mystery of the Identical Builds

The investigation started with something that looked broken: three separate builds of this model, targeting `target_fps` of 400,000, 800,000, and 1,200,000, all came back with **the exact same `auto_folding_config.json` and the exact same measured performance (~67k fps)**. Three wildly different requests, one identical answer.

The diagnosis came from doing the arithmetic FINN itself does internally:
target_cycles_per_frame = fclk_MHz × 1e6 / target_fps
At a 100 MHz clock:

| target_fps | required cycles/frame |
|---|---|
| 400,000 | 250 |
| 800,000 | 125 |
| 1,200,000 | 83 |

The model, at that point, was running at **1,491 cycles/frame** (≈67k fps) — 6 to 18 times slower than any of the three targets demanded. **All three targets were simultaneously unreachable.** `SetFolding`'s greedy per-layer algorithm keeps unfolding (raising PE/SIMD) node by node until it either hits the target or runs out of room it's willing to spend — and since none of the three requested targets were attainable at all, the algorithm ran to the exact same practical ceiling every time and stopped there, regardless of which impossible number it had been asked to hit.

**Lesson:** before trusting a `target_fps`, always sanity-check it against `fclk / target_fps` versus your current cycles/frame. If every target you throw at auto-folding produces the same config, that's not FINN being lazy — it's a sign every target so far has been out of reach, and auto-folding has already found its own ceiling.

---

## Chapter 2 — Chasing the Wrong Bottleneck (and Correcting Course)

The first hypothesis for "where's the real ceiling" was built purely from the **divisibility constraints table** (`MH % PE == 0`, `MW % SIMD == 0`), cross-referenced against the model's actual layer dimensions:

| Node | MH (out) | MW (in) | Current PE/SIMD | Room to grow? |
|---|---|---|---|---|
| MVAU_hls_0 (conv1) | 8 | 27 | PE=8, SIMD=9 | PE maxed; SIMD could → 27 |
| MVAU_hls_1 (conv2) | 16 | 72 | PE=8, SIMD=18 | PE → 16; SIMD → 24/36/72 |
| MVAU_hls_2 (conv3) | 32 | 144 | PE=8, SIMD=18 | PE → 16/32; SIMD → many options |
| MVAU_hls_3 (fc1) | 64 | 288 | PE=4, SIMD=18 | PE → 8/16/32/64 |
| MVAU_hls_4 (fc2) | 43 | 64 | PE=1, SIMD=8 | **PE can only be 1 or 43 — 43 is prime** |
| LabelSelect_hls_0 | 43 | — | PE=1 | same prime-43 constraint |

That last row looked, on paper, like the obvious villain: GTSRB has 43 classes, 43 is prime, and the constraint table's rule for `LabelSelect`/`Thresholding` leaves **no intermediate parallelism option** at all — it's PE=1 (serial) or PE=43 (fully parallel), nothing in between. The natural conclusion was that this serial final stage was capping the whole pipeline, and the fix proposed was to force the jump straight to PE=43.

Then the actual per-node cycle data came in, and it told a completely different story:

ConvolutionInputGenerator_rtl_3: 463 ← highest single node
Thresholding_rtl_0: 432 ← tied second
MVAU_hls_0: 432 ← tied second
...
LabelSelect_hls_0: 43 ← trivial

**`LabelSelect_hls_0` only cost 43 cycles.** It was never the bottleneck at all — it was one of the cheapest nodes in the entire network. The divisor-table reasoning had correctly identified a *real structural constraint*, but incorrectly assumed that constraint implied it was *the* bottleneck. It wasn't. The real offenders were an RTL window generator and a thresholding node, nowhere near the prime-43 stage.

**Lesson:** a divisibility constraint tells you where a node's *ceiling* is — it says nothing about whether that node is currently *limiting* anything. Always check the actual `estimate_layer_cycles.json` values before deciding which constraint matters.

There was also a side-quest here worth remembering: at that same moment, `rtlsim_performance.json` showed `"N": 1`, and `latency_cycles` (1490) was suspiciously almost identical to `interval_cycles` (1489) — a red flag that only one image had been simulated, meaning no pipeline overlap had been observed and "true" steady-state throughput was still unknown. That thread got set aside temporarily (folding decisions are made from analytical estimates, before rtlsim ever runs, so it doesn't affect folding choices — only the *measurement* of the result afterward), but it's a companion lesson: **don't trust a single-image rtlsim number as your throughput figure.**

---

## Chapter 3 — Finding the Real Ceiling: A Silent Resource Cap

With attention now correctly on the actual high-cycle nodes, a pattern emerged that explained *why* several of the MVAU layers were all stuck at the exact same SIMD value regardless of their different MW:

`MVAU_hls_1`, `MVAU_hls_2`, and `MVAU_hls_3` were all sitting at **SIMD=18** — not because 18 happened to be each one's individual legal maximum, but because of a hidden, global constraint: `mvau_wwidth_max` (default value **36**), which caps an MVAU's per-cycle weight-stream width via roughly `SIMD × weight_bits ≤ mvau_wwidth_max`. At 2-bit weights (`W2`), that caps SIMD at exactly 18 — `18 × 2 = 36`.

Meanwhile, several **other** nodes were sitting far below their legal maximum with no such cap justifying it:

| Node | Cycles | Current | Legal max | Headroom |
|---|---|---|---|---|
| ConvolutionInputGenerator_rtl_3 | **463** (worst of all 17) | SIMD=2 | 16 | 8x |
| Thresholding_rtl_0 | 432 (tied 2nd) | PE=1 | 3 | 3x |
| FMPadding_rtl_2 | 400 | SIMD=1 | 16 | 16x |
| ConvolutionInputGenerator_rtl_1 | 376 | SIMD=4 | 8 | 2x |
| ConvolutionInputGenerator_rtl_4 | 376 | SIMD=4 | 16 | 4x |
| MVAU_hls_4 (fc2) | 344 | SIMD=8 | 16 (under the wwidth cap) | 2x |

**Lesson:** two different phenomena can both leave a node "under-folded" — a real resource cap, or simply unclaimed headroom. Telling them apart matters: raising a resource cap costs more silicon per unit of speed; claiming free headroom on an under-utilized RTL node is often nearly free.

---

## Chapter 4 — A Gift From an Earlier Build: Real Post-Synthesis Data

Rather than continue reasoning from analytical estimates alone, a **full successful synthesis** of this model's default (conservative) folding config produced `post_synth_resources.json` — genuine, ground-truth resource numbers rather than pre-synthesis guesses. This was treated as a real gift: it let LUT-per-parallelism-unit ratios be calibrated from real data instead of extrapolated blind.

**The baseline this revealed:** 21,242 LUT / 53,200 available ≈ **39.9% utilization**, at only 67,069 fps. Enormous headroom — nearly 32,000 LUT of budget remained before even reaching 80%. Being "far less resource-hungry than its wider sibling `c12x24x36`" was noted explicitly: this model could afford to be considerably more aggressive.

**The bottleneck, confirmed against real data:** `ConvolutionInputGenerator_rtl_3` at 463 cycles — and per the real post-synth numbers, it cost only **139 LUT**. The single most valuable fix available: the worst offender in the whole design was simultaneously one of the cheapest nodes to fix. It was identified as the window generator feeding the second pooling stage (16 channels, after conv2), folded at SIMD=2 against a legal max of 16.

### The cycle formula, verified against real hardware behavior

The formula `ceil(MH/PE) × ceil(MW/SIMD) × output_pixels` was checked against all four real MVAU/FC cycle counts and matched exactly — e.g. `MVAU_hls_1: ceil(16/8) × ceil(72/18) × 36 = 2 × 4 × 36 = 288` ✓. This turned the next round of projections from guesses into precise predictions:

| Node | MH/MW | Current PE/SIMD → New | Cycles: current → new |
|---|---|---|---|
| MVAU_hls_0 (conv1) | 8/27 | SIMD 9→27 (full) | 432 → **144** |
| MVAU_hls_1 (conv2) | 16/72 | PE 8→16 (full) | 288 → **144** |
| MVAU_hls_2 (conv3) | 32/144 | PE 8→16 | 288 → **144** |
| MVAU_hls_3 (fc1) | 64/288 | PE 4→8 | 256 → **128** |
| MVAU_hls_4 (fc2) | 43/64 | SIMD 8→32 | 344 → **86** |

LUT cost was projected from the real per-node numbers, scaled linearly (flagged explicitly as a likely conservative *upper bound*, since fixed overhead typically amortizes better at higher parallelism than a pure linear model assumes):

`MVAU_hls_0`: 2729→~5458 · `MVAU_hls_1`: 2929→~5858 · `MVAU_hls_2`: 2984→~5968 · `MVAU_hls_3`: 1776→~3552 · `MVAU_hls_4`: 369→~1476 — **projected MVAU total: ~22,312 LUT**, up from 10,787, leaving roughly 20,000+ for everything else.

`mvau_wwidth_max` needed: `MVAU_hls_0` at SIMD=27, W2 → 54 bits; `MVAU_hls_4` at SIMD=32 → 64 bits. Set to exactly **64** — no more than needed.

### The cheap wins, done alongside

The RTL nodes (SWGs, Pool, FMPadding, Thresholding) cost tens to low hundreds of LUT each in the real data — maxing these against their channel counts was treated as nearly free compared to the MVAUs:
Thresholding_rtl_0 (MH=3): PE 1→3 (169 LUT, cheap)
ConvInputGen_1 (pool1, ch=8): SIMD 4→8
Pool_hls_0 (ch=8): PE 4→8 (match above)
FMPadding_rtl_1 (ch=8): SIMD 2→8
ConvInputGen_3 (pool2, ch=16): SIMD 2→16 ← the #1 bottleneck, 139 LUT node
Pool_hls_1 (ch=16): PE 2→16
FMPadding_rtl_2 (ch=16): SIMD 1→16
ConvInputGen_4 (conv3, ch=16): SIMD 4→16
**A deliberate omission, and why:** `parallel_window: 1` was *not* added anywhere new in this round, even though it had proven valuable elsewhere. The reasoning: this model's current auto-folding only used `parallel_window` on the very first layer, and there wasn't yet confirmed evidence it behaved correctly on the pooling-feeding SWGs in this specific FINN+ build. Flagged explicitly as "worth trying as a follow-up experiment once this baseline is validated, not bundled in blind."

**Lesson:** real post-synthesis data, when you have it, is worth far more than another round of analytical estimation — it lets you convert "should work" into "will cost approximately X." And knowing when *not* to bundle in an unverified technique (even one proven elsewhere) alongside a big, otherwise-well-evidenced change is its own discipline — isolate the risky variable so you can tell what worked.

---

## Chapter 5 — Discovering the 144-Cycle MVAU Floor

The aggressive config from Chapter 4 was run and landed at **28,083 LUT / 53,200 ≈ 52.8%** — real headroom remained (roughly +14,500 LUT to reach 80%), but the instinct to "push further" was checked against the numbers first, and this is where a second, more subtle insight appeared.

`MVAU_hls_0` was now at **PE=8=MH (full) and SIMD=27=MW (full)** — completely unrolled. At 144 output pixels (the 12×12 spatial size), that's a hard floor: **144 cycles minimum**, with no PE/SIMD lever left on this node at all.

Recomputing the other MVAUs with the same verified formula revealed something important — they were **already exactly tied to that same 144-cycle floor**, not still catching up to it:

| Node | PE/SIMD applied | Cycles | vs. 144 floor |
|---|---|---|---|
| MVAU_hls_0 | PE=8 (full), SIMD=27 (full) | 144 | *is* the floor |
| MVAU_hls_1 | PE=16 (full), SIMD=18 | ceil(72/18)=4 × 36px = **144** | exactly matched |
| MVAU_hls_2 | PE=16, SIMD=18 | ceil(32/16)=2 × ceil(144/18)=8 × 9px = **144** | exactly matched |
| MVAU_hls_3 | PE=8, SIMD=18 | 8×16×1px = **128** | already under |
| MVAU_hls_4 | PE=1, SIMD=32 | 43×2×1px = **86** | already under |

**This was not a coincidence — it meant the config was already exactly balanced at the one number that couldn't be improved without a fundamentally different technique.** Pushing `MVAU_hls_1` or `MVAU_hls_2`'s SIMD any further (e.g. 18→24 or 36) would have cost real LUT for **zero throughput improvement**, since the critical path was pinned at `MVAU_hls_0`'s unmovable 144.

**Lesson:** "push aggressively higher" is a trap once every MVAU in a pipeline converges on the same cycle count — that convergence *is* the signal that the aggressive move isn't more folding, it's recognizing where folding has already hit its structural ceiling. Continuing to spend resources past that point is pure waste.

---

## Chapter 6 — The `parallel_window` Breakthrough, Borrowed From a Sibling Model

Despite the MVAU layer being cleanly balanced at 144 cycles, the design's *actual* measured/estimated throughput came in at only **291,545 fps** — worse than the wider `c12x24x36` model's 462,963 fps, on a network that was supposed to be cheaper. That inversion was the signal something else was now the real bottleneck.

The new bottleneck: `ConvolutionInputGenerator_rtl_2` at **343 cycles** — and critically, this was **not** an under-folding problem. It was already channel-maxed at `SIMD=8=channels`. Something else was needed.

**The insight came from comparing the equivalent node across both sibling models directly:**

| Model | SWG config (conv2 stage) | Cycles |
|---|---|---|
| `c12x24x36` | SIMD=12=channels, **`parallel_window: 1`** | **66** |
| `c8x16x32` (this model) | SIMD=8=channels, `parallel_window: 0` | **343** |

Same structural role, same channel-maxed SIMD, and a >5x difference — the only distinguishing factor was `parallel_window`. SIMD alone only parallelizes across *channels*; without `parallel_window`, the generator still steps through the 3×3 kernel's window positions one at a time per output pixel. This was the exact lesson deliberately held back in Chapter 4 ("worth trying as a follow-up experiment once this baseline is validated, not bundled in blind") — now it was time to actually try it, informed by direct cross-model evidence rather than a guess.

**The honest caveat attached to this evidence:** the `c12x24x36` comparison point had only been run through `step_generate_estimate_reports`, not full synthesis — so this couldn't be promised to survive HLS/synthesis unchanged, only that the analytical model backed it strongly and it was cheap to test the same way everything else had been tested.

**The fix applied:**
```json
"ConvolutionInputGenerator_rtl_2": {
  "SIMD": 8,
  "parallel_window": 1,
  "ram_style": "distributed"
}
```
One change, everything else left as-is. Cost was projected as modest: this node's real post-synth LUT cost had been only 118 in the very first full build; the analogous node in `c12x24x36` (at a higher channel count, 12 vs 8) cost 336 LUT with `parallel_window` on — call it a few hundred LUT, trivial against the ~14,500 remaining headroom to 80%.

**Result: estimated throughput jumped from 291,545 fps to 505,050 fps**, at 52.8% LUT — confirming the hypothesis and, notably, beating the `c12x24x36` model's 462,963 fps on a genuinely cheaper network, which had been the original goal all along.

**Lesson:** when a sibling model or configuration shows a large, structurally-similar improvement from one specific parameter, it's worth deliberately testing that exact parameter in isolation on the new model — rather than assuming it transfers, or assuming it doesn't. The evidence from one context (even if imperfectly verified) is a strong hypothesis generator for another.

---

## Chapter 7 — Hitting a Genuine Architectural Floor

With the pipeline now running well, the new bottleneck was `ConvolutionInputGenerator_rtl_0` at 198 cycles, with `FMPadding_rtl_0` right behind it at 196. Both feed **conv1**, the network's 3-channel RGB input stage. Both were already at `SIMD=3=channels` **and** `parallel_window=1` — every folding lever available on these node types was already maxed.

**The arithmetic explained exactly why, and confirmed this wasn't a config gap:** the input is 12×12, padded by 1 on each side for the 3×3 kernel → **14×14 = 196 padded pixels**. `FMPadding_rtl_0`'s cycle count matched that number exactly. `ConvolutionInputGenerator_rtl_0`'s 198 was that same number plus a couple of pipeline-fill cycles. With channels already fully parallelized (SIMD=3=C) and the whole 3×3×3 window already extracted in a single shot (`parallel_window=1`), the only thing left serializing this node was **walking across the 196 spatial positions of the padded image, one per cycle** — a genuine architectural floor for a 3-channel, 12×12 input at this technique, not an under-folded config waiting to be discovered.

A healthy secondary sign accompanied this: the second-place node, `ConvolutionInputGenerator_rtl_1` (146 cycles, the pool1-feeding SWG at 8 channels, also already fully SIMD+window maxed), was close to this same floor for the same structural reason — meaning the whole pipeline had converged near its natural ceiling together, rather than being dragged down by one lagging outlier. That's a sign of a well-balanced design, not a design still full of easy wins.

**What was deliberately not attempted:** rather than invent an unverified parameter to push past this floor, the honest limit of current knowledge was stated plainly — there may exist a multi-pixel-per-cycle (MMV) mechanism in FINN's window generator for exactly this kind of spatial bottleneck, but without confidently-verified details on whether it's exposed as a simple folding-config field in this specific FINN+ build, or how safe it would be to apply blind, it was flagged as "worth a targeted doc/source check before trying" rather than guessed at.

**Lesson, and the close of this model's story:** not every bottleneck is a folding problem. Once every available parallelism axis (channels via SIMD, kernel window via `parallel_window`) is maxed on the nodes at the top of the cycle-count list, and the remaining cycle count exactly matches a spatial/geometric property of the input (padded pixel count, in this case), further gains would require a fundamentally different technique — not a more aggressive application of the same one. Recognizing that boundary, and stopping to verify rather than guess past it, is as important a skill as finding the bottleneck in the first place. At that point, this model had gone from 67,069 fps (39.9% LUT) to an estimated 505,050 fps (52.8% LUT) — a roughly 7.5x improvement, on a network cheaper than its sibling, while still holding real resource margin in reserve.
---


# FINN / FPGA Dataflow Acceleration — Working Notes
_A reference on FINN's build flow, folding, PE/SIMD, and resource tuning, distilled from a GTSRB-on-PYNQ-Z2 deployment project._

---

## 1. The Big Picture: What FINN Actually Does

FINN takes a quantized neural network (via Brevitas → QONNX export) and turns it into a **streaming dataflow accelerator**: instead of one shared compute unit that loops over layers (like a CPU/GPU), FINN instantiates **one dedicated hardware block per layer**, all connected in a pipeline, each layer streaming its output directly into the next layer's input. Throughput is determined by whichever layer is slowest (the "bottleneck" or "critical path" node), because in steady state every stage works on a different image simultaneously (pipelining).

This has a major consequence for tuning: **you're not optimizing average-case compute, you're balancing a pipeline.** Speeding up a layer that isn't the bottleneck does nothing for throughput — it only costs resources. This single idea underlies almost every folding decision below.

---

## 2. The FINN Build Pipeline (Step Order Matters)

A `finn build config.yaml` run executes a `steps:` list, each step transforming the ONNX graph further toward hardware. Key steps and what they actually do:

1. **`step_qonnx_to_finn`** — Converts QONNX (Brevitas export format) into FINN-ONNX, lowering `Quant` nodes toward `MultiThreshold` representations.
2. **Custom input/output transform step(s)** (e.g. `mymodule.step_my_custom_step`) — if you need to merge a normalization graph, annotate input datatypes, insert TopK/argmax, etc. Runs early, right after `step_qonnx_to_finn`, so downstream streamlining can algebraically absorb your preprocessing math.
3. **`step_tidy_up`** — graph cleanup, shape inference.
4. **`step_streamline`** — this is where a LOT of the "magic" happens: it algebraically folds simple ops (division, mean/std subtraction, batchnorm, etc.) into the thresholds of the nearest `MultiThreshold` node. This is *why* you can inject a plain normalization module in front of the graph and have it become "free" in hardware — streamlining absorbs it into existing threshold computations rather than instantiating separate hardware for it.
5. **`step_convert_to_hw`** — converts streamlined ops into **generic/abstract** FINN hardware operators (e.g. `MVAU`, `Thresholding`, `Pool`, `ConvolutionInputGenerator`), tagged with domain `finn.custom_op.fpgadataflow`. These are backend-agnostic at this point — not yet HLS or RTL implementations.
6. **`step_create_dataflow_partition`** — wraps the eligible dataflow-capable subgraph into a `StreamingDataflowPartition`, and subsequent steps operate on that extracted child model.
7. **`step_specialize_layers`** — **critical, easy to forget.** Converts the generic abstract HW ops from step 5 into concrete backend implementations (`_hls` or `_rtl` suffixed ops, e.g. `MVAU_hls`, `ConvolutionInputGenerator_rtl`). Downstream folding/performance-analysis code specifically filters for these specialized ops — **omitting this step causes internal errors in later steps that expect specialized nodes to exist** (they'll find none, since the abstract ops don't count).
8. **`step_target_fps_parallelization`** — runs `SetFolding`, which tries to choose PE/SIMD (and related folding parameters) for every layer so that the *estimated* cycles-per-frame hits your requested `target_fps`, subject to resource caps like `mvau_wwidth_max`. Operates purely on **analytical/estimated** cycle counts (not real synthesis, not rtlsim) — see §7.
9. **`step_apply_folding_config`** — if you supply a `folding_config_file`, this applies your **manual** overrides on top of (or instead of) the automatic result.
10. **`step_generate_estimate_reports`** — cheap, no synthesis; produces `estimate_layer_cycles.json`, `estimate_network_performance.json`, `estimate_layer_resources.json`. **Always run this before committing to expensive downstream steps** — it's your first checkpoint to sanity-check a folding config.
11. **`step_hw_codegen` / `step_hw_ipgen`** — generates actual HLS/RTL and runs HLS synthesis per node.
12. **`step_insert_dwc`** — inserts DataWidthConverters wherever adjacent nodes have mismatched stream widths (e.g. from asymmetric folding choices between neighboring layers).
13. **`step_set_fifo_depths`** — sizes inter-stage FIFOs to keep the pipeline from stalling; can itself run an RTL-simulation-based sizing pass (`AutoFIFOSizingMethod.LARGEFIFO_RTLSIM` is a common default), which takes real time.
14. **`step_create_stitched_ip`** — stitches all per-node IP into one accelerator IP block.
15. **`step_measure_rtlsim_performance`** — runs an actual RTL simulation of the stitched design and measures real cycles/latency/interval. See §7 for the N=1 pitfall.
16. **`step_out_of_context_synthesis`** — runs Vivado synthesis on just the accelerator logic (no full board/shell integration) to get **real post-synthesis resource counts and achievable clock frequency**, much cheaper than a full bitfile build. **Good practice: use this as a checkpoint before committing to full synthesis**, especially after any aggressive folding change.
17. **`step_synthesize_bitfile`** — full Vivado synthesis + implementation with the board shell (DMA, AXI, clocking) — the expensive, slow step.
18. **`step_make_driver`** — generates the PYNQ driver.

---

## 3. PE and SIMD — What They Actually Mean

For a matrix-vector-style hardware unit (MVAU, representing a Conv or FC layer):

- **MH** ("matrix height") = number of **output** channels/neurons for that layer.
- **MW** ("matrix width") = number of **input** values consumed per output, i.e. `in_channels × kernel_height × kernel_width` for a conv layer, or just `in_features` for an FC layer.
- **PE** (Processing Elements) = how many **output** channels are computed **in parallel**, per cycle. Must satisfy `MH % PE == 0`.
- **SIMD** = how many **input** elements are consumed **in parallel**, per cycle, per PE. Must satisfy `MW % SIMD == 0`.

Increasing PE and/or SIMD trades **hardware resources (LUTs, sometimes DSPs/BRAM) for lower cycle count** (higher throughput), up to the point where `PE == MH` and `SIMD == MW` (fully unrolled — one output pixel's full computation happens in a single cycle, no folding left at all).

**Cycle formula (empirically verified against real FINN output in this project):**

    cycles_for_layer ≈ ceil(MH / PE) × ceil(MW / SIMD) × num_output_pixels

This is extremely useful for hand-predicting the effect of a folding change before spending time on a rebuild.

### The divisibility trap

Because PE and SIMD must be **exact divisors** of MH and MW respectively, layers whose MH/MW factor into few divisors can have big, unavoidable jumps between folding options. Example encountered in this project: a layer with `MW = 27 = 3³` only has legal SIMD values `{1, 3, 9, 27}` — there's no way to land at, say, SIMD=15. Sometimes this forces you into "fully unroll or stay slow" with nothing in between — this is architectural, not a config mistake, and it's worth checking a layer's actual divisors before assuming a "medium" setting exists.

### The prime-number trap

If a layer's MH (output count) is a **prime number** — e.g. a 43-class classifier's final FC layer / LabelSelect (argmax) stage — then PE can *only* be `1` or the full prime value. There is no partial-parallelism option. Going from PE=1 to PE=43 is a huge one-shot resource jump, not a gradual scaling knob. Worth explicitly checking whether your final classification stage is actually your bottleneck before deciding whether that jump is worth it (in one real case here, it was NOT the bottleneck at all — spending resources to unlock it would have been wasted).

---

## 4. Folding Configuration Files

- Supplied via the `folding_config_file` field in the build YAML.
- Applied by `step_apply_folding_config`, layered on top of / instead of the automatic `SetFolding` result.
- **Format**: a JSON object keyed by node name (matching the specialized op names from `step_specialize_layers`, e.g. `MVAU_hls_0`, `ConvolutionInputGenerator_rtl_3`, `Thresholding_rtl_0`, `Pool_hls_1`, `LabelSelect_hls_0`), each holding a dict of nodeattr overrides (`PE`, `SIMD`, `ram_style`, `resType`, `mem_mode`, `parallel_window`, etc).
- **The automatically-generated `auto_folding_config.json`** (found in each build's `report/` output) is the best starting point to hand-edit — it shows you the current values and every node's exact name.
- Node names are only knowable *after* running through `step_specialize_layers` at least once — inspect an intermediate/auto config file rather than guessing names.

### Practical workflow that worked well in this project

1. Run with `target_fps` set to something (doesn't have to be perfectly tuned) to get a baseline `auto_folding_config.json` and `estimate_layer_cycles.json`.
2. Identify the bottleneck node (`max_cycles_node_name` in `estimate_network_performance.json`).
3. Check whether that node has legal room to fold further (compare current PE/SIMD against MH/MW divisors, or against channel count for RTL SWG/Pool/FMPadding nodes).
4. Edit `auto_folding_config.json` → save as your own `folding_manual.json` → point `folding_config_file` at it.
5. Re-run **only through `step_generate_estimate_reports`** (cheap, no synthesis) and check the new bottleneck + resource totals.
6. Iterate steps 2–5 until the bottleneck stops moving meaningfully or resource usage approaches your budget.
7. **Only then** proceed to `step_out_of_context_synthesis` (cheap-ish, real numbers) before ever running the full bitfile build (expensive).

---

## 5. `target_fps` vs. Reality — Why Auto-Folding Can Silently Plateau

`SetFolding` (triggered by `step_target_fps_parallelization`) tries to hit your `target_fps`, but it works entirely from **analytically estimated** cycle counts — not real hardware measurement. Two important failure modes observed in this project:

1. **Requesting an unreachable target_fps.** If `target_fps` implies a cycles-per-frame count far below what the architecture can achieve even at maximum legal folding, `SetFolding` will just run to its own internal ceiling and stop — silently. Symptom: **multiple builds with wildly different `target_fps` values (e.g. 400k / 800k / 1.2M) all converge to the exact same `auto_folding_config.json` and the exact same measured performance.** This isn't a bug — always sanity check by computing `target_cycles_per_frame = fclk_MHz × 1e6 / target_fps` and comparing it against what your current folding already achieves.

2. **A hidden resource cap silently limiting folding.** `mvau_wwidth_max` (default `36`) caps the per-cycle **weight stream width** into an MVAU: roughly `SIMD × weight_bit_width ≤ mvau_wwidth_max`. At 2-bit weights, this caps SIMD at 18 regardless of how far MW's divisors would otherwise allow — and this shows up as multiple different MVAU layers all independently topping out at the *same* SIMD value (18, in this project's case) even though their MW values differ. Raising `mvau_wwidth_max` (e.g. to 64 or 72) unlocks further SIMD scaling on 2-bit-weight layers, at the cost of more resource usage per node — compute the exact bits needed for your target SIMD (`SIMD × weight_bits`) and set the cap to just cover it, not arbitrarily high.

---

## 6. The `parallel_window` Parameter — A Second, Separate Axis of Parallelism

For `ConvolutionInputGenerator` (sliding-window generator, SWG) nodes: **SIMD alone only parallelizes across input *channels*.** Even with SIMD maxed to equal the channel count, the SWG will still step through the K×K kernel window positions **one at a time per output pixel** unless `parallel_window: 1` is also set. This is a genuinely separate lever from SIMD, and skipping it left one SWG node in this project running at **463 cycles when the true achievable value (with both channels and window parallelized) was 66** — over 7x difference, and it was one of the *cheapest* nodes to fix (only ~100–300 LUT).

**Rule of thumb:** for any `ConvolutionInputGenerator` node whose SIMD is already fully maxed against its channel count, check whether `parallel_window: 1` is set before assuming that node is out of options.

**Caveat**: full parallel-window benefit generally also expects the *downstream* MVAU to be able to consume a whole window per cycle (`SIMD = MW` on that MVAU) to avoid a width mismatch — if the MVAU's SIMD is smaller, FINN will typically auto-insert a DataWidthConverter (`step_insert_dwc`) to bridge the mismatch rather than fail, but this costs a bit of extra LUT and may not realize the full theoretical speedup. Not extensively verified in this project beyond the auto-DWC-insertion behavior being observed and accepted.

---

## 7. Understanding the Different Performance Reports — Don't Mix Them Up

FINN produces multiple, **fundamentally different**, cycle/throughput numbers at different pipeline stages. Confusing them was a repeated source of confusion in this project:

| Report | Produced by | What it actually measures | Trustworthiness |
|---|---|---|---|
| `estimate_layer_cycles.json` | `step_generate_estimate_reports` | Per-node **analytical** cycle estimate, from formulas based on PE/SIMD/MH/MW — no synthesis or simulation involved | Good for fast iteration; formula-based, verified accurate against real FINN output in this project |
| `estimate_network_performance.json` | same | `max_cycles` = the single slowest node (the bottleneck / critical path in steady state); `estimated_throughput_fps` derived from it | Good directional signal, same caveats as above |
| `estimate_layer_resources.json` | same | Per-node **analytical** LUT/BRAM/DSP estimate | Useful, but **does not include** FIFOs, DataWidthConverters, or board-shell/DMA/AXI infrastructure — real usage will be higher, sometimes substantially |
| `rtlsim_performance.json` | `step_measure_rtlsim_performance` | **Actual RTL simulation** of the stitched pipeline. Reports `latency_cycles` (time for one image to traverse the whole pipeline) and `interval_cycles` (time between consecutive outputs — the true throughput number) | Only trustworthy for throughput if `N` (number of images simulated) is large enough to reach pipeline steady state |
| `post_synth_resources.json` | after `step_out_of_context_synthesis` (or full synth) | **Real, ground-truth** post-synthesis resource usage, broken down per instantiated hardware block including FIFOs/DWCs/IODMA | Most trustworthy resource number available before a full bitfile build |

### The N=1 pitfall (important!)

By default, `rtlsim_batch_size` (a real, documented `DataflowBuildConfig` field, default `1`) means only **one image** is simulated. With N=1, there's no second image to pipeline-overlap with the first, so `interval_cycles` ends up ≈ `latency_cycles` — i.e. you're measuring **single-shot latency**, not steady-state throughput, and it will look far worse than the design's real capability. **Set `rtlsim_batch_size` to something like 100 before trusting `rtlsim_performance.json`'s throughput number.**

---

## 8. Resource-Tuning Levers Beyond PE/SIMD

- **`resType`**: `"lut"` vs `"dsp"` — controls whether MAC operations map to LUT fabric or to dedicated DSP48 slices. For very low bit-widths (e.g. 2-bit weights), LUT-based MACs are often more efficient than DSPs, since a DSP48 handling one low-precision MAC wastes most of its native 18×25 multiplier width — this is likely why `resType: "lut"` was the sensible default throughout this project. Still, if LUTs are the binding constraint and DSPs are sitting completely idle (0% used), it can be worth experimentally trying `resType: "dsp"` on the largest LUT-consuming node to see if it helps, even knowing the packing may be imperfect.
- **`mem_mode`**: `"internal_decoupled"` vs `"internal_embedded"` — controls whether an MVAU's weights live in BRAM (streamed in) or are baked directly into logic/ROM. `internal_decoupled` allocates BRAM in whole-block granularity (e.g. 18Kb chunks) **regardless of how few bits are actually needed** — for a layer with a genuinely tiny weight count, this can result in BRAM "efficiency" figures under 1%, i.e. almost the entire allocated block is wasted. Switching such tiny layers to `internal_embedded` recovers that BRAM, generally at the cost of some additional LUT — worth doing only when BRAM (not LUT) is your binding constraint.
- **`ram_style`**: `"auto"`, `"distributed"`, `"block"`, `"ultra"` — hints for how memories should be implemented; `"auto"` generally left alone unless a specific resource type is under pressure.

---

## 9. Bottleneck-Driven Tuning Strategy (General Method)

The single most reliable strategy across this whole project boiled down to:

1. **Never uniformly scale everything up.** Different nodes have wildly different cost-per-cycle-saved. Look at `estimate_layer_cycles.json`, find the actual bottleneck (`max_cycles_node_name`), and fix *that* first.
2. **Cheap RTL nodes first.** `ConvolutionInputGenerator`, `Pool`, `FMPadding`, `Thresholding` nodes are usually far cheaper (tens to low hundreds of LUT) than MVAUs (thousands of LUT) — maxing these out is almost always a "free" win if they're not already at their channel-count ceiling.
3. **Watch for a matched ceiling.** Once your MVAU layers are folded to a point where they all land on the *same* cycle count, that number is your effective floor for that layer type — pushing any one of them further wastes resources for zero throughput gain, since the pipeline is bounded by the slowest stage regardless. Recompute the bottleneck after every change rather than assuming "more folding = more speed."
4. **Recognize spatially-bound bottlenecks.** Some nodes (e.g. an input-stage SWG on a small number of channels) can be fully maxed on every folding parameter (SIMD=channels, `parallel_window=1`) and still be limited simply by the number of **spatial positions** in the (padded) input/output feature map — there's no further folding lever left, this is architectural, not a config gap. Recognizing this early avoids wasted tuning cycles.
5. **Slack-recovery pass.** After chasing the bottleneck down, check every *other* node for cycle counts far below the new bottleneck — those are over-provisioned and can be folded back down to just-under-bottleneck to recover LUT for free, with zero throughput cost. This was a genuinely free win in this project (recovered several thousand LUT with no fps change).
6. **Validate with real numbers before scaling further.** Analytical estimates are good for fast iteration but drift from reality once FIFOs/DWCs/shell overhead stack up. Use `step_out_of_context_synthesis` as a checkpoint, not just `step_generate_estimate_reports`, before trusting a folding config enough to commit to a full bitfile build.

---

## 10. Miscellaneous Lessons

- **Output quantization isn't always necessary.** If the network's final stage feeds directly into an argmax/TopK (`LabelSelect`) rather than needing calibrated output values, and the last layer uses **per-tensor** weight quantization (single shared scale across all outputs), then argmax is invariant to that shared scale — an extra output `QuantIdentity` changes the numeric values but never changes which class wins. Skipping it avoids unnecessary clipping risk for zero classification benefit. This would NOT hold if the network used **per-channel** output quantization (different scale per class) — in that case, ranking could change and an output quantizer would matter.
- **FINN's estimation and folding logic is layer-local.** It reasons about MH/MW/PE/SIMD divisibility and per-node resource caps — it does not have a "global" or your-total-chip-budget-aware model in `SetFolding` itself; you are responsible for checking aggregate resource totals against your actual FPGA's budget.
- **The formula-based cycle prediction is worth doing by hand.** Before spending a build cycle, `ceil(MH/PE) × ceil(MW/SIMD) × output_pixels` lets you predict a folding change's exact effect on a node's cycle count without touching the tool at all — extremely useful for planning which lever is worth pulling.
- **A wider/deeper network is not automatically slower in hardware than a narrower one**, once folding is properly tuned for each — resource *efficiency* of the chosen folding matters more than raw parameter count. In this project, a smaller channel-width network ended up matching/beating a larger one on throughput once its own bottlenecks (not the larger model's) were correctly identified and addressed.

---

## 11. Quick-Reference Checklist for a New Folding Attempt

1. Get a baseline: run with any reasonable `target_fps`, capture `auto_folding_config.json` + `estimate_layer_cycles.json` + `estimate_network_performance.json`.
2. Compute `target_cycles_per_frame = fclk_MHz × 1e6 / target_fps` — sanity check it's actually reachable before chasing it further.
3. Identify `max_cycles_node_name` — that's the only node whose speed currently matters.
4. For that node: is it an MVAU? Check MH/MW divisors for PE/SIMD headroom, and check `mvau_wwidth_max` isn't silently capping it.
5. Is it a `ConvolutionInputGenerator`? Check SIMD vs channel count, and whether `parallel_window` is set.
6. Apply the fix, re-run only through `step_generate_estimate_reports`, recheck the bottleneck — it will likely have moved to a different node. Repeat.
7. Once the bottleneck stabilizes or resource usage approaches budget, do a slack-recovery pass on over-provisioned nodes.
8. Validate real throughput with `rtlsim_batch_size` set high enough (e.g. 100) before trusting the number.
9. Checkpoint resource reality with `step_out_of_context_synthesis` before committing to a full bitfile build.
10. Only then run the full `step_synthesize_bitfile` flow.

---





# FINN PYNQ-Z2 Deployment: Comprehensive Notes & Analysis

## Part 1: Performance Takeaways & Analysis

### 1. Evaluation Results Summary
* **Hardware Throughput:** ~137,000 FPS (Achieved via Python/Jupyter on PYNQ-Z2)
* **Model Accuracy:** 89.29% (For W2A3 quantization on GTSRB dataset)
* **Theoretical vs. Real-World Gap:** ~30% of the ~448k FPS RTL simulation throughput is standard for a host-driven system.

### 2. Bottleneck Breakdown (Why physical FPS < RTL simulation)
1. **Idealized Simulation:** RTL simulation assumes instant data availability at inputs/outputs, ignoring physical memory bounds.
2. **PS-PL Bottleneck (AXI DMA):** Moving image arrays back and forth between the ARM CPU's DDR memory (PS) and the FPGA fabric (PL) over the AXI interconnect saturates the Zynq-7020 memory bandwidth.
3. **Python & PYNQ Overhead:** Calling `accel.execute()` in a Python loop introduces OS context switches, cache flushing, and register writing overhead that accumulates at high frame rates.

### 3. Strategies to Reach ~448k FPS (Commercial/Production Optimization)
* **Ditch Python:** Transition to a bare-metal C++ application to manage DMA registers directly and eliminate software overhead.
* **Increase Batch Sizes:** Pass larger batches (e.g., 10,000 images) to better amortize DMA setup time.
* **Bypass CPU (Direct Streaming):** Stream pixels straight into the FPGA logic from a hardware source (e.g., MIPI camera sensor) without touching ARM CPU/DDR memory.

### 4. Final Verdict
Achieving ~137k FPS with an 89.29% accuracy rate using a Python environment on the Zynq-7020 is a complete success. The hardware accelerator is fully optimized and is no longer the system bottleneck.

---

## Part 2: Resource Synthesis Takeaways

### 1. Pre-Synthesis vs. Post-Synthesis Discrepancies
* **HLS Pessimism:** Pre-synthesis numbers aggregate isolated layer estimates, lacking global design context. 
* **Vivado Optimization:** Post-synthesis reflects holistic cross-layer optimizations, resource sharing, and device-specific mapping.

### 2. The BRAM Mapping Shift (69 HLS vs. 54 Equivalent Actual)
* **Distributed RAM / LUTRAM Conversion:** Shallow memory structures designated for weights/FIFOs map to LUTRAMs rather than wasting full 18K BRAM blocks (`ram_style: auto`).
* **SRL Mapping for FIFOs:** Shallow inter-layer FIFOs map more efficiently to Shift Register LUTs (SRLs).
* **BRAM Packing:** Vivado combines separate 18K requests into dual-port 36K BRAM blocks, reducing total block count.

### 3. Shift Register LUTs (SRLs: 2,324)
* **Line Buffers:** `ConvolutionInputGenerator` nodes use SRLs to stream pixels into MVAU matrix multipliers.
* **Shallow FIFOs:** Inter-layer data balancing FIFOs use SRL32 primitives instead of dedicated memory blocks.

### 4. Flip-Flop Count (41,191 FFs)
* **Healthy Ratio:** A ~1:1 ratio with LUTs (~40k) is standard for heavily pipelined FPGA fabrics.
* **Core Drivers:** Driven by deep MVAU pipeline registers, AXI-Stream interface handshakes (`valid`/`ready`/`data`), and multi-cycle popcount accumulators.