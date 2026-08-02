# Task 3 — FINN Folding Optimization (TFC-W1A1 MNIST MLP)

Part of the **Neural Network Acceleration on FPGAs** lab (CDNC, KIT).

This task explores FINN's **folding** mechanism — the PE (Processing
Element) / SIMD hardware parallelism knobs that trade FPGA resource
usage against throughput — first via FINN's automatic `target_fps`-driven
folder, then through iterative manual tuning, working with a pre-trained
4-layer binarized MLP (`TFC-W1A1`, 784→64→64→64→10) trained on MNIST.

## Objectives

1. Run the provided `TFC-W1A1` accelerator bitstream on the PYNQ-Z2 board
   and validate baseline functionality/accuracy.
2. Compile a fresh bitstream from ONNX using FINN(+), first via
   **automatic folding** targeting a given FPS.
3. Use the auto-generated folding config as a starting point for
   **manual folding**, iteratively maximizing hardware utilization and
   throughput until synthesis fails, respecting FINN's
   [PE/SIMD divisor constraints](https://finn.readthedocs.io/en/latest/internals.html#constraints-to-folding-factors-per-layer).
4. Compare automatic vs. manual folding at matched/higher target FPS.

## Directory Structure

```
task3/
├── dump/                              # scratch / intermediate run artifacts
├── models/
│   ├── tfc-w1a1.onnx                  # baseline model (1-bit weights, 1-bit activations)
│   ├── tfc-w1a1-flattened.onnx        # tfc-w1a1 with input pre-flattened to [1,784]
│   ├── tfc-w1a2.onnx                  # 1-bit weights, 2-bit activations variant
│   └── tfc-w2a2.onnx                  # 2-bit weights, 2-bit activations variant
├── results/
│   ├── output_auto/                   # FINN automatic-folding build (target_fps)
│   ├── output_custom_0/               # manual fold #0
│   ├── output_custom_1/               # manual fold #1
│   ├── output_custom_2/               # manual fold #2
│   ├── output_custom_3/               # manual fold #3
│   ├── output_custom_4/               # manual fold #4
│   └── output_custom_4_batchsize1000/ # final, correct, hightest throughput run
│       └── ...                        # each follows FINN's standard dataflow-build
│                                       # layout: report/, bitfile/, driver/, intermediate models
├── custom_0_folding_config.json
├── custom_1_folding_config.json
├── custom_2_folding_config.json
├── custom_3_folding_config.json
├── custom_4_folding_config.json
├── build.yaml                         # finn build configuration (configured for the output_custom_4_batchsize1000 run)
└── .gitignore
```

## Setup

```bash
# From the FINN(+) environment
finn deps update   # accept defaults; run twice (needed on first-time setup)
finn deps update
```

`build.yaml` controls the model being compiled and the folding strategy —
edit it to select **either**:

```yaml
target_fps: 100000
output_dir: directory_to_save_finn_build_outputs
```

**or**, for manual folding:

```yaml
# target_fps: 100000              # commented out
folding_config_file: path_to_folding_config_json_file
output_dir: directory_to_save_finn_build_outputs
# also make sure the build.yaml points to the correct model
```
- To reproduce the results, the build.yaml has to be correctly configured. 
Pay attention to the notes below to know the suitable configuration for each run.

then:

```bash
source /path/to/Vivado/2022.2/settings64.sh   # or appropriate version
finn build build.yaml
```

Reports of interest after each build:
`estimate_network_performance.json`, `estimate_layer_cycles.json`,
`estimate_layer_resources.json`, `rtlsim_performance.json`,
`post_synth_resources.json`.

To inspect the model architecture directly (needed to know legal
PE/SIMD divisors per layer), open the intermediate
`step_target_fps_parallelization.onnx` in [netron.app](https://netron.app)
with attributes shown (`Ctrl+D`).

## Board Testing (PYNQ-Z2)

1. Upload `fpgannlab.zip` via the Jupyter interface, `unzip` it under
   `/home/xilinx/jupyter_notebooks`.
2. Open `test_mnist.ipynb` → **Run All** to validate baseline
   (pre-provided) bitstreams and check reported accuracy.
3. To test a **newly compiled** bitstream: rename the generated
   `.bit`/`.hwh` files from `results/output_<name>/.../bitfile/` to
   something identifying the fold (e.g. `tfc_w1a1_custom3.bit/.hwh`),
   upload to the board's `bitfiles/` folder, and point cell 1 of
   `test_mnist.ipynb` at the new filename.
4. The I/O shape dict required for cell 1 is generated per-build in the
   driver's `settings.json` — adapt the notebook cell to match if it
   differs from the default.

## Experiments & Results

All builds target a 100 MHz clock in simulation (`fclk = 100 MHz`)
unless noted otherwise.

| Build | Bottleneck layer | Max cycles (est.) | Estimated throughput | RTL-sim (stable) throughput | LUT | BRAM_36K | BRAM_18K | DSP |
|---|---|---:|---:|---:|---:|---:|---:|---:|
| `output_auto` | `MVAU_hls_0` | 896 | 111,607 fps | **30,534 fps** | 8,220 | 3 | 4 | 0 |
| `output_custom_0` | `Reshape_rtl_0` / `Thresholding_rtl_0` (PE=1, unfolded) | 784 | — | — | — | — | — | — |
| `output_custom_1` | `Reshape_rtl_0` / `Thresholding_rtl_0` (PE=28) | 28 | 3,571,429 fps | **1,265,823 fps** | 26,790 | 79 | 3 | 0 |
| `output_custom_2` | `MVAU_hls_0` (input flattened, Thresholding PE=112) | 14 | 7,142,857 fps | **1,818,182 fps** | 27,893 | 79 | 3 | 0 |
| `output_custom_3` | `Thresholding_rtl_0` / `MVAU_hls_0` tied (PE=64) | 7 | 14,285,714 fps | **1,923,077 fps** | *(pending)* | *(pending)* | *(pending)* | 0 |
| `output_custom_4` | `MVAU_hls_0` (PE=32, scaled back from 64) | 14 | 7,142,857 fps | **1,612,903 fps** *(N=1 — see note below)* | 27,820 | 79 | 3 | 0 |
| `output_custom_4_batchsize1000` | `MVAU_hls_0` (same bitstream as `custom_4`) | 14 | 7,142,857 fps | **~5,000,000 fps** *(N=1000, steady-state)* † | 27,820 *(same bitstream)* | 79 | 3 | 0 |

`output_custom_0` MVAU-layer folding numbers/resources aren't captured
above from this chat's trace — pull the exact PE/SIMD values from
`custom_0_folding_config.json` and its build reports directly if you
want to fill this row in.

† `custom_4_batchsize1000`'s throughput is reported here as given by the
batched rtlsim run; the exact `rtlsim_performance.json` for that run
(interval_cycles, N, latency_cycles breakdown) wasn't captured for this
write-up. Append it if you want the exact figures rather than the
rounded ~5,000,000 fps headline number.

**Post-synthesis timing (implementation) result — `output_custom_3`:**
the most aggressive fold **did not close timing at the assumed 100 MHz**
— actual achieved F<sub>max</sub> after implementation was **~83 MHz**.
This matters: every throughput figure above for `custom_3` (including
the 1.92M fps "stable" rtlsim number) is a *cycle-accurate simulation*
result computed at an assumed 100 MHz clock — rtlsim performs no timing
analysis. The real, deployable throughput for that configuration is
better estimated as:

```
real_throughput ≈ rtlsim_throughput × (achieved_Fmax / assumed_Fmax)
                ≈ 1,923,077 fps × (83 / 100)
                ≈ 1,596,000 fps   (estimated — confirm against actual
                                    board/post-synth timing report)
```

**Post-synthesis timing (implementation) result — `output_custom_4`:**
unlike `custom_3`, this configuration **does close timing at the full
100 MHz target**. Post-route timing analysis confirms:

```
WNS = +0.241 ns   TNS = 0.000 ns   0 failing endpoints
All user specified timing constraints are met.
```

The previous worst path (`LabelSelect_hls_0`, 14 logic levels,
WNS = ‑1.922 ns) is gone; the new worst path sits inside `MVAU_hls_0`
(8 logic levels, comfortably met). `custom_4` (and
`custom_4_batchsize1000`, which shares the same bitstream) is therefore
the **only configuration in this study with a fully closed 100 MHz
timing report** — every rtlsim throughput number for `custom_3` above
needed a derating correction; `custom_4`'s numbers don't.

## The Optimization Journey

**1. Baseline (`output_auto`):** automatic target-fps folding gave a
conservative fold (e.g. `MVAU_hls_0` at PE=2, SIMD=28) — safe, but
leaving throughput far below what the hardware budget allows: rtlsim
throughput of 30,534 fps sits **3.6× below** the estimate report's own
111,607 fps figure, an early sign that estimate-report numbers and
actual simulated behavior diverge meaningfully even at conservative
folding.

**2. First manual fold (`output_custom_0`):** pushed `MVAU_hls_*` PE/SIMD
up substantially while leaving `Reshape_rtl_0`/`Thresholding_rtl_0`
untouched at PE=1. This is where the real bottleneck was discovered:
**no amount of MVAU folding matters once `Reshape_rtl_0` is capped at
784 cycles** — it silently dictates a hard throughput ceiling of
`100MHz / 784 ≈ 127,551 fps` regardless of downstream parallelism.

**3. Chasing the Reshape bottleneck — a wrong turn first.** Attempting
to raise `Reshape_rtl_0`'s own PE directly hit a hard FINN assertion
(`PE must divide last axis`). The first hypothesis — that this "last
axis" was the image's channel dimension (NHWC convention, forcing
PE=1 permanently for grayscale input) — turned out to be **wrong**: the
model's actual input tensor is `[1, 1, 28, 28]` (**NCHW**), so the
constrained axis is **W = 28**, giving legal values
`{1, 2, 4, 7, 14, 28}` rather than being unconditionally locked to 1.
Lesson generalized to the rest of the task: **verify the actual tensor
shape at the actual node** (`model.get_tensor_shape(...)` on the
relevant intermediate `.onnx`) rather than reasoning from a remembered
layout convention.

**4. `output_custom_1` — PE=28 fix.** Set `Reshape_rtl_0` and
`Thresholding_rtl_0` to PE=28 (the max legal divisor of 28), collapsing
their cycle count from 784 → 28. Result: a **41× jump** in rtlsim
throughput (30,534 → 1,265,823 fps) — by far the single largest gain of
the whole exercise, confirming the Reshape/Thresholding pair really was
the dominant bottleneck. Cost: LUT usage more than tripled (8,220 →
26,790), and BRAM_36K jumped **26×** (3 → 79).

**5. `output_custom_2` — flattening the input graph.** Rather than
continue folding around the 28-cycle ceiling imposed by the 4D
`[1,1,28,28]` shape, the ONNX graph's input was flattened to `[1, 784]`
directly (`tfc-w1a1-flattened.onnx`) — removing `Reshape_rtl_0` from the
graph entirely rather than trying to parallelize it further.
`Thresholding_rtl_0` then inherited the full `784`'s divisor range,
letting it fold down to PE=112 (7 cycles). Result: another **44% gain**
in rtlsim throughput (1,265,823 → 1,818,182 fps), with only a marginal
resource increase (LUT 26,790 → 27,893) — a cleaner win than fighting
the original node's constraint.

**6. `output_custom_3` — closing the gap on `MVAU_hls_0`.** With
Thresholding no longer the sole bottleneck, `MVAU_hls_0`'s PE was pushed
32 → 64, halving its cycle count (14 → 7) to match Thresholding. The
*estimate* report predicted another 2× throughput jump — but **rtlsim
throughput improved by only ~5.8%** (1,818,182 → 1,923,077 fps). This is
the most instructive data point in the whole exercise (see Key Finding 4)
— and, as it turned out, this configuration also failed to close timing
in implementation (~83 MHz achieved, not 100 MHz — see the table note
above), meaning even its modest rtlsim gain overstated real deployable
throughput.

**7. `output_custom_4` — Scaling Back `MVAU_hls_0` and Fixing the Real
Timing Bottleneck**

To guarantee timing closure at 100 MHz, `MVAU_hls_0`'s PE was scaled
back from 64 (`custom_3`) to 32. This restores its execution time to
**14 cycles per image** (matching `output_custom_2`), re-establishing
it as the primary throughput bottleneck in the streaming dataflow
pipeline — trading away `custom_3`'s higher estimated-throughput ceiling
for a design that can actually be implemented at the target clock.

Crucially, `MVAU_hls_0`'s folding wasn't actually the cause of
`custom_3`'s timing failure. Post-route analysis of the failing path
showed `LabelSelect_hls_0` (still at `PE=5`, unchanged since `custom_2`)
was the true worst path: at `PE=5`, HLS unrolls the 10-way argmax into a
single combinational chain **14 logic levels deep** (WNS = ‑1.922 ns) —
consistent with a sequential running-max/argmax loop being flattened
rather than reduced as a balanced tree, so logic depth scales with PE
rather than `log₂(PE)`. Reducing `LabelSelect_hls_0` to `PE=1` forces
HLS to stop unrolling the comparisons combinationally and instead
pipeline them one comparison per cycle, collapsing the 14-level chain
into single-level pipeline stages.

Post-route timing confirms this worked: **WNS = +0.241 ns, 0 failing
endpoints — full closure at 100 MHz**, with the new worst path now
inside `MVAU_hls_0` itself (8 logic levels, comfortably within budget).
This is the first, and only, configuration in the whole study to
actually close timing at the target clock.

At `PE=1`, `LabelSelect_hls_0`'s own latency rises to ~10 cycles — still
under `MVAU_hls_0`'s 14-cycle interval, so in principle it shouldn't add
to the steady-state bottleneck. A same-day, single-image (`N=1`) rtlsim
run appeared to *contradict* this: total cycle count rose from 52
(`custom_3`, N=1) to 62 (`custom_4`, N=1), suggesting a ~16% throughput
regression from the `LabelSelect` change. This turned out to be a
measurement artifact — see step 8 and Key Finding 7.

**8. `output_custom_4_batchsize1000` — Batched Simulation Reveals the
Real Steady-State Throughput**

Same bitstream and folding as `custom_4` — the only difference is
`rtlsim_batch_size: 1000` set in `build.yaml`, simulating 1000
back-to-back images instead of 1. This amortizes the pipeline's
one-time fill/drain latency (which dominates an `N=1` measurement)
across the full batch, converging on the design's true steady-state
interval instead.

Result: **~5,000,000 fps** — roughly **3× higher** than the `N=1`
figure for the exact same bitstream, and reasonably close to the
`MVAU_hls_0`-bound theoretical ceiling of
`100 MHz / 14 cycles ≈ 7,142,857 fps` (~70% pipeline efficiency, a
plausible number given FIFO/handshake overhead between dataflow
stages). This retroactively supports the reasoning in step 7:
`LabelSelect_hls_0` at `PE=1` does **not** meaningfully bottleneck
steady-state throughput once measured properly — the apparent 16%
regression seen in the `N=1` test was an artifact of single-image
simulation, not a real hardware cost of the fix. (See Key Finding 7 for
the general lesson.)

### A few CRUCIAL notes:
- custom_X uses the folding configuration defined in `custom_X_folding_config.json`
   - e.g. custom_2 uses `custom_2_folding_config.json`
   - note: custom_4_batchsize1000 uses the folding configurtion defined in custom_4_folding_config, since they are basically the same folding architecture
- auto, custom_0, custom_1: use tfc-w1a1.onnx model  
- custom_2, custom_3, custom_4, custom_4_batchsize1000: use tfc-w1a1-flattened.onnx model  
- custom_4_batchsize1000 is the exact same run as custom_4 with the exception that a batch size of 1000 is simulated
   - `rtlsim_batch_size: 1000` was set in the build.yaml

## Key Findings

1. **A single unfolded node upstream can cap the entire pipeline**,
   regardless of how aggressively everything downstream is folded —
   always audit *every* node in `estimate_layer_cycles.json`, not just
   the obviously compute-heavy layers.
2. **Don't guess a tensor-shape constraint from convention** — a wrong
   assumption (NHWC vs. this model's actual NCHW layout) led toward a
   much more invasive proposed fix (full ONNX graph surgery) than the
   real one needed. A one-line shape check would have caught it
   immediately.
3. **Sometimes the right fix isn't folding around a bottleneck — it's
   removing the node that causes it.** Flattening the graph input
   (`output_custom_2`) outperformed trying to squeeze more parallelism
   out of `Reshape_rtl_0` as originally structured.
4. **The estimate report and rtlsim increasingly diverge as folding
   gets aggressive.** Going from `output_custom_2` → `output_custom_3`,
   the *estimated* max-cycle bottleneck halved (14→7 cycles, i.e. a
   predicted 2× throughput gain) but real rtlsim throughput barely
   moved (+5.8%) — past a certain point, fixed pipeline/FIFO overhead
   the per-layer cycle estimate doesn't model dominates, and chasing
   the reported bottleneck stops being the highest-value optimization.
5. **Resource cost scales steeply with folding aggressiveness across
   the whole design**, not just the tuned layer: LUT grew ~3.4×
   (8,220→27,893) and BRAM_36K ~26× (3→79) between baseline and
   `output_custom_2`.
6. **rtlsim throughput assumes the target clock closes timing — verify
   this post-synthesis.** `custom_3`'s rtlsim numbers assumed 100 MHz
   but only ~83 MHz was achievable in implementation — folding
   aggressiveness trades off against achievable F<sub>max</sub>, not
   just LUT/BRAM count, and the true throughput ceiling for an
   aggressive fold can only be confirmed after implementation, not from
   rtlsim alone. `custom_4` is the first fold in this study to actually
   pass that check (WNS = +0.241 ns at 100 MHz).
7. **A single-image (`N=1`) rtlsim run badly underestimates real
   throughput — always batch-simulate before comparing folding options.**
   `custom_4`'s `N=1` run reported 1,612,903 fps; the identical bitstream
   simulated with `rtlsim_batch_size=1000` reported ~5,000,000 fps —
   roughly **3× higher**. A one-shot simulation conflates the pipeline's
   one-time fill/drain latency with its steady-state interval, so any
   folding decision judged only against an `N=1` cycle count risks being
   wrong: the apparent "16% throughput cost" of moving `LabelSelect_hls_0`
   from `PE=5` to `PE=1` (seen only in the `N=1` numbers) essentially
   disappeared once measured at steady state — set `rtlsim_batch_size`
   to something large (≥100–1000) before drawing conclusions from a
   throughput comparison.
8. **Timing closure and throughput are both necessary — neither alone
   tells the full story.** `custom_3` had the best *estimated* and
   best *N=1 rtlsim* throughput in this study, but never closed timing
   in implementation, so its real-world throughput was always going to
   be lower than reported. `custom_4` traded away some of that
   estimated ceiling (`MVAU_hls_0` PE 64→32) but is the only
   configuration confirmed to close timing at 100 MHz **and**, once
   properly batch-simulated, deliver high real throughput (~5M fps) —
   making it the actual best deliverable of the whole exercise, not
   the one with the flashiest single-run number.

## Other Models

`tfc-w1a2.onnx` and `tfc-w2a2.onnx` are available under `models/` for
further experimentation (per the task's "feel free to play around with
the other models" prompt) but weren't part of the documented deep-dive
above — the same folding methodology applies directly.