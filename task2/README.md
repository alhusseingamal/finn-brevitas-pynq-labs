# Task 2 — VHDL MLP Accelerator (Iris Dataset)

Part of the **Neural Network Acceleration on FPGAs** lab (CDNC, KIT).

A hand-written VHDL implementation of a small MLP (4 → 8 → 8 → 3
neurons) for Iris classification — no HLS or automated flow — to build
intuition for the low-level datapath (FINN's MVTU PE, binary/bipolar
MAC-and-threshold) that later tasks generate automatically.

## Model

- 3 layers: 8 neurons (first layer, bipolar `{-1,1}` weights),
  8 neurons (hidden, binary weights), 3 neurons (output, binary
  weights, one per class)
- Inputs: 4× 8-bit unsigned integers, packed into a 32-bit input word
- Binary-weight MAC (XNOR + popcount) and thresholding implemented to
  complete in a single clock cycle each, per the FSM (`idle → mult →
  sum → act`) guided by FINN's MVTU PE datapath (Fig. 2 of the task PDF)

## Directory Structure

```
task2/
├── dump/
│ ├── NN_lab_intro.pdf # task statement
│ └── notes.md
└── mlp/
├── neuron.vhdl # single neuron: FSM, binary/bipolar MAC + threshold
├── layer.vhdl # instantiates neurons, generates "done" signal
├── neuralnetwork.vhdl # chains layers, argmax over output layer
├── types.vhdl # shared array type definitions
├── iris_bnn.vhdl # testbench, reads iris_test_X.txt, prints predictions
├── iris_test_X.txt # test vectors (hex-packed inputs)
├── ghdl_run.sh # GHDL simulation runner
└── output.log # captured simulation output
```

## Running

Simulated with **GHDL** (in addition to / instead of Vivado's ISim, per
the task PDF's Vivado-based instructions):

```bash
cd mlp
./ghdl_run.sh
```

Predicted class labels are printed to console/`output.log`, one per
line of `iris_test_X.txt`.

Equivalently, this can be run inside Vivado following the task PDF:
create an RTL project targeting the **PYNQ-Z2** board part, add all
files in `mlp/` (VHDL 2008, do *not* copy into project), and run a
**Behavioral Simulation**, observing `iris_bnn`'s `input`, `start`,
`done`, `output`, `clk`, and `current_state` of one neuron per layer.

## Verification

Simulation output was checked against the expected predicted labels
given in the task PDF (30 test vectors, classes 0/1/2) — match
confirmed via `output.log`.