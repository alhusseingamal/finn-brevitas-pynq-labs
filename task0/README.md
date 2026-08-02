# Task 0 – Development Environment Setup

This task prepares your development environment for the FPGA Neural Network Acceleration laboratory. By the end of this task, you should have all required software installed and verified, providing a working environment for the remaining tasks in this repository.

> **Reference:** KIT FPGA NN Lab – *Task 0: Setup* :contentReference[oaicite:0]{index=0}

---

## Objectives

- Install and configure **Miniconda**
- Create a dedicated Python environment
- Install:
  - PyTorch
  - Brevitas
  - ONNX
  - QONNX
  - FINN-related packages
- Install **AMD/Xilinx Vivado 2022.1**
- Verify that the complete toolchain is functioning correctly

---

## Requirements

- Ubuntu 18.04 or newer (recommended)
- Python 3.11 (via Conda)
- Approximately:
  - **4.5 GB** for the Python environment
  - **30 GB** for Vivado after installation
  - Up to **160 GB** temporarily during Vivado installation :contentReference[oaicite:1]{index=1}

---

## Setup Steps

Complete the setup in the following order:

1. Install **Miniconda**
2. Create the `nnlab` Conda environment
3. Install PyTorch and Brevitas
4. Install ONNX/QONNX/FINN dependencies
5. Install **Vivado 2022.1**
6. Verify the installation using the provided test models :contentReference[oaicite:2]{index=2}

---

## Installation Verification

After completing the installation:

- Run the provided ONNX model with the supplied test script.
- Compute the inference cost using the `qonnx-inference-cost` utility.
- Launch Vivado and verify that projects can be opened successfully. :contentReference[oaicite:3]{index=3}

---

## Deliverable

A fully functional development environment capable of:

- Training and evaluating quantized neural networks with Brevitas
- Running ONNX/QONNX tooling
- Synthesizing FPGA designs using Vivado
- Supporting all subsequent tasks in this repository

---

## Official Documentation

The complete setup instructions are provided in:

**Task-0-setup.pdf**

Follow the document carefully and perform each step in order.
