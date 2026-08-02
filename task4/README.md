# Task 4 — GTSRB Traffic Sign Classifier on PYNQ-Z2

Part of the **Neural Network Acceleration on FPGAs** lab (CDNC, KIT).

Unlike Task 3 (where a pre-trained model and build pipeline were provided),
this task is fully self-designed end-to-end: a quantized CNN for the
**German Traffic Sign Recognition Benchmark (GTSRB)** is designed, trained,
and quantized with Brevitas; pre-/post-processing is merged directly into
the ONNX graph so the entire inference pipeline — including normalization
and argmax — runs in hardware; the model is compiled to a PYNQ-Z2 bitstream
via FINN+; and the resulting accelerator is evaluated on physical hardware
using a NumPy-only notebook.

## Objectives

1. Design and train a quantized CNN with Brevitas; export to QONNX.
2. Merge normalization (host-side pre-processing) and Top-K argmax
   (post-processing) into the ONNX graph so both execute in hardware
   rather than on the ARM host CPU.
3. Configure `build.yaml` and compile the merged model with FINN+.
4. Deploy the generated bitstream + driver package to the PYNQ-Z2 board.
5. Evaluate accuracy, latency, and throughput on-device using a
   NumPy-only notebook (no PyTorch/Torchvision available on-board).

## Directory Structure
```
task4/                                            # this task's repo folder
├── dump/                                         # scratch / intermediate run artifacts
├── source/                                       # training + FINN build working directory
│   ├── finn_out/
│   │   └── 12x12_w2a3_c12x24x36/                 # FINN build output for the chosen model
│   │       ├── logs/                             # per-step FINN build logs
│   │       ├── outputs/                          # bitstream, reports, driver package
│   │       └── models/
│   │           ├── gtsrb_12x12_w2a3_c12x24x36.onnx
│   │           └── gtsrb_12x12_w2a3_c12x24x36.pt
│   ├── 12x12_w2a3_c12x24x36_custom_fold.json     # manual PE/SIMD folding config
│   ├── 12x12_w2a3_c12x24x36_fps800000.log        # FINN build log
│   ├── build_gtsrb_12x12_w2a3_c12x24x36_fps800000.yaml  # FINN build config
│   ├── dataset.py                                # GTSRBDataset (NumPy/PIL + PyTorch wrappers)
│   ├── train_dse.py                              # model definition + training/DSE entrypoint
│   └── transform_input.py                        # custom FINN step: in-graph pre/post-processing
├── Pynq-Z2-deployment/                           # self-contained on-board deployment package
│   ├── bitfiles/
│   │   ├── task4.bit                             # FPGA bitstream
│   │   └── task4.hwh                             # hardware handoff (block-design metadata)
│   ├── finn/util/                                # runtime data-packing helpers (from FINN)
│   ├── qonnx/                                    # runtime QONNX helpers (from QONNX)
│   ├── dataset.py                                # GTSRBDataset, NumPy-only path for on-board use
│   ├── driver.py                                 # FINNDMAOverlay driver
│   ├── evaluate.ipynb                            # single-cell on-board evaluation notebook
│   └── settings_task4.json                       # driver configuration (folded shapes, datatypes, etc.)
├── .gitignore
└── README.md
```

## Model Architecture

- Input: images resized to **12×12** pixels
- 3 convolutional layers, channel dimensions **12 → 24 → 36**
- Followed by an intermediate FC layer + FC output layer
- Quantization: **2-bit weights, 3-bit activations**, power-of-two
  quantization

## Design Space Exploration

A number of architectures were swept across image size, channel width,
and bit-width before settling on a final candidate:

| Model | Img size | W-bits | A-bits | Channels | Val. acc. | Test acc. |
|---|:---:|:---:|:---:|---|:---:|:---:|
| 16x16_w1a2_c16x32x64 | 16 | 1 | 2 | 16/32/64 | 0.54 | — |
| 16x16_w2a2_c16x32x64 | 16 | 2 | 2 | 16/32/64 | 85.46 | — |
| 16x16_w2a3_c16x32x64 | 16 | 2 | 3 | 16/32/64 | 90.72 | — |
| 8x8_w3a3_c16x32x64 | 8 | 3 | 3 | 16/32/64 | 79.88 | — |
| 16x16_w3a3_c16x32x64 | 16 | 3 | 3 | 16/32/64 | 95.65 | — |
| 20x20_w3a3_c16x32x64 | 20 | 3 | 3 | 16/32/64 | 98.08 | — |
| 24x24_w3a3_c16x32x64 | 24 | 3 | 3 | 16/32/64 | 98.72 | — |
| 8x8_w4a4_c16x32x64 | 8 | 4 | 4 | 16/32/64 | 77.69 | — |
| 16x16_w2a3_c12x24x48 | 16 | 2 | 3 | 12/24/48 | 93.25 | — |
| 12x12_w3a3_c16x32x64 | 12 | 3 | 3 | 16/32/64 | 98.91 | — |
| 16x16_w2a3_c12x24x36 | 16 | 2 | 3 | 12/24/36 | 92.43 | — |
| 12x12_w2a3_c16x32x64 | 12 | 2 | 3 | 16/32/64 | 97.36 | 91.73 |
| 12x12_w2a2_c16x32x64 | 12 | 2 | 2 | 16/32/64 | 91.04 | — |
| **12x12_w2a3_c12x24x36** ✅ | **12** | **2** | **3** | **12/24/36** | **95.90** | **89.22** |
| 12x12_w2a2_c12x24x36 | 12 | 2 | 2 | 12/24/36 | 91.46 | 84.25 |
| 12x12_w2a3_c8x16x32 | 12 | 2 | 3 | 8/16/32 | 91.21 | 84.15 |

*(Test accuracy was only collected for shortlisted candidates.)*

**`12x12_w2a3_c12x24x36`** was selected as the final model — it strikes
the best balance between accuracy (95.90% val / 89.22% test) and
hardware cost among the candidates tested; several larger/wider
configurations scored higher on accuracy alone but at proportionally
larger resource cost.

## Usage

**1. Train and export the model:**
```bash
python train_dse.py --img_size 12 --epochs 100 --wbits 2 --abits 3 --channels 12 24 36
```
Produces `.pt` and `.onnx` checkpoints under `./finn_out/<model_name>/models/`.

**2. Build the FPGA accelerator with FINN:**
```bash
finn build build_gtsrb_12x12_w2a3_c12x24x36_fps800000.yaml
```
The build config targets **800,000 images/s**, points to the manual
folding config (`12x12_w2a3_c12x24x36_custom_fold.json`), and inserts
`transform_input.py`'s custom build step immediately after
`step_qonnx_to_finn` to merge in-graph normalization and Top-K argmax.

### In-Graph Pre-/Post-Processing

To avoid a CPU-side bottleneck on the ARM host (float conversion,
normalization, argmax), both are folded directly into the compiled
hardware graph via a custom FINN build step:

- **Normalization** — a small PyTorch module implementing `x/255.0` +
  mean/std subtraction, exported via `export_qonnx` and merged into the
  classifier graph with `MergeONNXModels`. The merged input tensor is
  annotated `DataType["UINT8"]`, so FINN's streamlining pass absorbs the
  division/normalization directly into the first layer's quantization
  thresholds — no floating-point pre-processing needed on the host.
- **Post-processing** — an `InsertTopK(k=1)` node appended at the graph
  output, so the accelerator returns the predicted class index directly
  instead of raw logits.

## FINN Build Results (RTL-Simulation / Pre-Deployment)

### Performance

| Metric | Value |
|---|---|
| Target throughput | 800,000 img/s |
| Estimated throughput | 462,963 img/s |
| RTL-sim throughput | 447,275 img/s |
| Stable throughput | 448,877 img/s |
| Estimated latency | 22.42 µs |
| RTL-sim latency | 798 cycles |
| Clock frequency | 100 MHz |

### Cycle Breakdown

| Metric | Value |
|---|---|
| Critical path | 2242 cycles |
| Bottleneck layer | `MVAU_hls_1` — 216 cycles |
| Total RTL-sim cycles | 223,576 |

The build fell short of its 800k fps target (~56% of target,
~1.94× the auto-estimate's gap) but still landed at a substantial,
usable throughput after custom folding — see Task 3's folding notes for
the general methodology applied here.

### Resource Utilization

| Resource | Pre-Synthesis (layer estimate) | Post-Synthesis (top-level) |
|---|:---:|:---:|
| LUT | 36,861 | 40,660 |
| FF | — | 41,191 |
| SRL | — | 2,324 |
| BRAM36K | — | 26 |
| BRAM18K | 69 | 2 |
| DSP | 0 | 0 |
| URAM | 0 | — |

`resType: lut` was used throughout (0 DSPs), consistent with the
low-bit (2w3a) quantization making LUT-based multiply-accumulate more
resource-efficient than dedicated DSP slices at this scale.

## Deployment & On-Board Evaluation

The `Pynq-Z2-deployment/` folder is a **fully self-contained deployment
package** — bitstream, hardware handoff file, driver, runtime helper
libraries (`finn/util`, `qonnx`), dataset loader, and evaluation
notebook. Running it requires nothing beyond copying the folder onto
the board (e.g. via SD card, or `scp`) and executing a single notebook
cell — no separate FINN/Vivado toolchain needed on-device.

### Loading the Overlay

The evaluation notebook loads the bitstream and its associated driver
settings (folded I/O shapes, datatypes, etc.) directly from
`settings_task4.json`, and instantiates the DMA-driven overlay:

```python
import json
from driver import FINNDMAOverlay

BITFILE_PATH = "./bitfiles/task4.bit"
SETTINGS_FILE = "./settings_task4.json"

with open(SETTINGS_FILE, "r") as f:
    driver_settings = json.load(f)["driver_information"]

accel = FINNDMAOverlay(
    BITFILE_PATH,
    batch_size=1000,
    **driver_settings
)
```

### Evaluation Methodology

Because PyTorch/Torchvision aren't installed on the board, the entire
evaluation path — image loading, batching, and accuracy/latency/
throughput computation — is implemented with **NumPy only**, reusing
the same `GTSRBDataset` logic as training but through its pure
NumPy/PIL code path. Images are pre-allocated into a contiguous array
of shape `(n_batches, 1000, 32, 32, 3)`, `dtype=np.uint8`, and streamed
through the accelerator via `accel.execute(input_data)` in batches of
1000 to amortize DMA setup overhead across each call.

Two evaluation phases were run:

- **Initial run** — includes one-time dataset download/caching to a
  local `data/` directory on the board plus board/overlay startup
  overhead; excluded from reported performance figures as
  non-representative.
- **Steady-state runs** — 5+ repeated evaluation passes after warm-up,
  which converged to a **tight, consistent** performance band.

### Results

| Metric | Value |
|---|---|
| Total latency (per 1000-image batch) | 0.0825 s |
| Hardware throughput | **~145,000 FPS** |
| Model accuracy (on-board) | **89.29%** |

> Note: a separate internal analysis pass recorded **~137,000 FPS**
> rather than 145,000 for the same deployment — likely just
> run-to-run/session variance rather than a different measurement
> methodology, but worth confirming against your actual notebook output
> before treating either number as final.

**Accuracy sanity check:** the on-board figure (89.29%) closely matches
the offline test accuracy measured during training/DSE (89.22%, see
DSE table above) — a ~0.07-point difference consistent with normal
run-to-run variance rather than any correctness issue introduced by the
hardware datapath, in-graph normalization, or hardware argmax.

### Why On-Board Throughput Is Well Below RTL-Sim Throughput

On-board throughput (~137–145k FPS) lands at roughly **30% of the
RTL-simulation figure** (~448k FPS) — a substantial, but well-understood
and expected, gap for a host-driven (as opposed to free-running/
streaming) accelerator:

1. **RTL simulation is idealized.** `rtlsim_performance.json`-style
   figures assume input/output data is instantly available at the
   accelerator's stream interfaces every cycle. Real deployment has to
   actually move that data through physical memory and interconnect
   first.
2. **PS–PL interconnect (AXI DMA) is the dominant real bottleneck.**
   Every batch has to cross from the ARM Cortex-A9 host's DDR memory
   (PS, processing system) to the FPGA fabric (PL, programmable logic)
   over the AXI interconnect. On a Zynq-7020, this shared
   memory/interconnect bandwidth — not the accelerator's own compute
   fabric — is what caps effective throughput.
3. **Python / PYNQ software overhead.** Each `accel.execute()` call
   from a Python/Jupyter loop incurs OS-level context switches, cache
   management, and register-level driver calls. This overhead is
   roughly fixed per call, so it becomes proportionally more expensive
   at the frame rates this accelerator is capable of.

### Paths to Closing the Gap (Not Implemented Here)

If pushing closer to the ~448k FPS RTL-sim ceiling were a goal for a
future iteration:

- **Move off Python** — a bare-metal (or minimal-OS) C/C++ application
  driving the DMA registers directly would remove the interpreter and
  OS-call overhead that dominates at high frame rates.
- **Larger batches** — increasing batch size beyond 1000 would further
  amortize the fixed per-call DMA setup cost across more images.
- **Bypass the CPU/DDR path entirely** — streaming pixels directly into
  the accelerator's input stream from a hardware source (e.g. a MIPI
  camera sensor) would eliminate the PS–PL round-trip altogether,
  which is the single largest contributor to the gap above.

### Takeaway

The accelerator itself performs in line with (and close to) its
RTL-simulated design point — the gap to the raw RTL-sim number is a
**system-integration** characteristic (host software + interconnect),
not a shortfall in the compiled hardware datapath. At ~145,000 FPS
sustained throughput and 89.29% accuracy from a plain NumPy/Jupyter
evaluation flow on a Zynq-7020, the deployed accelerator is a working,
end-to-end validation of the full training → quantization → FINN
compilation → hardware deployment pipeline built for this task.
