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
│   └── output_custom_3/               # manual fold #3 (final, highest throughput)
│       └── ...                        # each follows FINN's standard dataflow-build
│                                       # layout: report/, bitfile/, driver/, intermediate models
├── custom_0_folding_config.json
├── custom_1_folding_config.json
├── custom_2_folding_config.json
├── custom_3_folding_config.json
├── build.yaml
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
output_dir: output_auto
```

**or**, for manual folding:

```yaml
# target_fps: 100000              # commented out
folding_config_file: custom_3_folding_config.json
output_dir: output_custom_3
```

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

`output_custom_0` MVAU-layer folding numbers/resources aren't captured
above from this chat's trace — pull the exact PE/SIMD values from
`custom_0_folding_config.json` and its build reports directly if you
want to fill this row in.

**Post-synthesis timing (implementation) result:** the most aggressive
fold (`output_custom_3`) **did not close timing at the assumed 100 MHz**
— actual achieved F<sub>max</sub> after implementation was **~83 MHz**.
This matters: every throughput figure above (including the 1.92M fps
"stable" rtlsim number for custom_3) is a *cycle-accurate simulation*
result computed at an assumed 100 MHz clock — rtlsim performs no timing
analysis. The real, deployable throughput for that configuration is
better estimated as:

```
real_throughput ≈ rtlsim_throughput × (achieved_Fmax / assumed_Fmax)
                ≈ 1,923,077 fps × (83 / 100)
                ≈ 1,596,000 fps   (estimated — confirm against actual
                                    board/post-synth timing report)
```

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
the most instructive data point in the whole exercise (see below).

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
   this post-synthesis.** The highest-throughput fold only achieved
   ~83 MHz in implementation, not the 100 MHz every cycle-based
   estimate assumes — a reminder that folding aggressiveness trades
   off against achievable F<sub>max</sub>, not just LUT/BRAM count, and
   that the true throughput ceiling for an aggressive fold can only be
   confirmed after implementation, not from rtlsim alone.

## Other Models

`tfc-w1a2.onnx` and `tfc-w2a2.onnx` are available under `models/` for
further experimentation (per the task's "feel free to play around with
the other models" prompt) but weren't part of the documented deep-dive
above — the same folding methodology applies directly.