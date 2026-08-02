#!/bin/bash

# Ensure output directory for logs exists
mkdir -p elgs

echo "================================================="
echo "Starting Expanded 8-Run GTSRB DSE (100 Epochs)"
echo "================================================="

# Experiment 6: W2A3 @ 12x12
echo "[6/8] Running Exp 6: 12x12 W2A3 (100 Epochs, channels 16-32-64)..."
python train_dse.py --img_size 12 --epochs 100 --wbits 2 --abits 3 --channels 16 32 64 > model-dse-logs/12x12_w2a3_12x24x36.log 2>&1

# Experiment 7: W1A3 @ 12x12 (Extreme Lowres + Binary Weights)
echo "[7/8] Running Exp 7: 12x12 W1A3 (100 Epochs, channels 24-48-96)..."
python train_dse.py --img_size 12 --epochs 100 --wbits 1 --abits 3 --channels 24 48 96 > elgs/exp7_12x12_w1a3_wide.log 2>&1

# Experiment 9: Extreme Logic Compression (W2A2 @ 12x12)
python train_dse.py --img_size 12 --epochs 100 --wbits 2 --abits 2 --channels 16 32 64 > elgs/exp9_12x12_w2a2.log 2>&1 &

# Experiment 10: Tapered Channels (W2A3 @ 12x12, 12-24-36)
python train_dse.py --img_size 12 --epochs 100 --wbits 2 --abits 3 --channels 12 24 36 > model-dse-logs/12x12_w2a3_12x24x36.log 2>&1 &