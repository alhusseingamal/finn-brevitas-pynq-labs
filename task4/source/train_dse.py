import os
import time
import random
import argparse
import numpy as np
import torch
import torch.nn as nn
from torch.nn import Module
import brevitas.nn as qnn
from brevitas.quant.scaled_int import Int8ActPerTensorFloat, Int8WeightPerTensorFloat, Uint8ActPerTensorFloat
from brevitas.core.restrict_val import RestrictValueType
from brevitas.export import export_qonnx

from dataset import get_gtsrb_datasets

class IntWeightPerTensorPoT(Int8WeightPerTensorFloat):
    restrict_scaling_type = RestrictValueType.POWER_OF_TWO


class IntActPerTensorPoT(Int8ActPerTensorFloat):
    restrict_scaling_type = RestrictValueType.POWER_OF_TWO


class UnsignedActPerTensorPoT(Uint8ActPerTensorFloat):
    restrict_scaling_type = RestrictValueType.POWER_OF_TWO


class TinyCNV(Module):

    def __init__(self, img_size=16, channels=[12, 24, 36], weight_bits=3, act_bits=3, in_bits=8):
        super(TinyCNV, self).__init__()

        c1, c2, c3 = channels

        self.in_quant = qnn.QuantIdentity(act_quant=IntActPerTensorPoT, bit_width=in_bits, return_quant_tensor=True)

        # Block 1
        self.conv1 = qnn.QuantConv2d(3, c1, kernel_size=3, padding=1, weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)
        self.bn1 = nn.BatchNorm2d(c1)
        self.relu1 = qnn.QuantReLU(act_quant=UnsignedActPerTensorPoT, bit_width=act_bits, return_quant_tensor=True)
        self.pool1 = nn.MaxPool2d(kernel_size=2, stride=2)

        # Block 2
        self.conv2 = qnn.QuantConv2d(c1, c2, kernel_size=3, padding=1, weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)
        self.bn2 = nn.BatchNorm2d(c2)
        self.relu2 = qnn.QuantReLU(act_quant=UnsignedActPerTensorPoT, bit_width=act_bits, return_quant_tensor=True)
        self.pool2 = nn.MaxPool2d(kernel_size=2, stride=2)

        # Block 3
        self.conv3 = qnn.QuantConv2d(c2, c3, kernel_size=3, padding=1, weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)
        self.bn3 = nn.BatchNorm2d(c3)
        self.relu3 = qnn.QuantReLU(act_quant=UnsignedActPerTensorPoT, bit_width=act_bits, return_quant_tensor=True)
        self.use_pool3 = (img_size >= 16)   # avoid 3rd pooling for small images (< 16 pixels) to prevent collapsing the spatial structure too much
        if self.use_pool3:
            self.pool3 = nn.MaxPool2d(kernel_size=2, stride=2)

        # calculate flattened dimension: 3 poolings --> image dimension is halved three times /(2^3), 2 poolings --> image dimension is halved two times /(2^2)
        spatial_dim = (img_size // 8) if self.use_pool3 else (img_size // 4)    # dimension after pooling
        flattened_dim = (spatial_dim ** 2) * c3 # flattened dimension = spatial_dim * spatial_dim * no. of output channels

        self.fc1 = qnn.QuantLinear(flattened_dim, 64, bias=False, weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)
        self.relu4 = qnn.QuantReLU(act_quant=UnsignedActPerTensorPoT, bit_width=act_bits, return_quant_tensor=True)

        self.fc2 = qnn.QuantLinear(64, 43, bias=False, weight_bit_width=weight_bits, weight_quant=IntWeightPerTensorPoT)

    def forward(self, x):
        x = self.in_quant(x)

        # Block 1
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu1(x)
        x = self.pool1(x)

        # Block 2
        x = self.conv2(x)
        x = self.bn2(x)
        x = self.relu2(x)
        x = self.pool2(x)

        # Block 3
        x = self.conv3(x)
        x = self.bn3(x)
        x = self.relu3(x)
        if self.use_pool3:
            x = self.pool3(x)

        x = torch.flatten(x, 1)

        # FC layers
        x = self.fc1(x)
        x = self.relu4(x)
        x = self.fc2(x)
        return x


def evaluate(model, data_loader, device):
    model.eval()
    correct, total = 0, 0
    with torch.no_grad():
        for images, labels in data_loader:
            images, labels = images.to(device), labels.to(device)
            out = model(images)
            pred = out.argmax(1, keepdim=True)
            correct += pred.eq(labels.data.view_as(pred)).sum().item()
            total += images.size(0)
    return (correct * 100.0) / total


def train_and_export(img_size=16, epochs=70, lr=0.003, bsize=256, wbits=3, abits=3, channels=[12, 24, 36], seed=42, resume_path=None):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    torch.backends.cudnn.deterministic = True
    torch.backends.cudnn.benchmark = False
    
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    print(f"\n=======================================================")
    print(f"Testing Resolution: {img_size}x{img_size} | Bits: W{wbits}A{abits} | Seed: {seed}")
    print(f"=======================================================")

    # retrieve all 3 splits from GTSRB dataset helper
    train_dataset, val_dataset, test_dataset = get_gtsrb_datasets(data_dir="./data", img_size=img_size, val_split=0.15)
    
    train_loader = torch.utils.data.DataLoader(train_dataset, batch_size=bsize, shuffle=True, num_workers=4)
    val_loader = torch.utils.data.DataLoader(val_dataset, batch_size=bsize, shuffle=False, num_workers=4)
    test_loader = torch.utils.data.DataLoader(test_dataset, batch_size=bsize, shuffle=False, num_workers=4)

    model = TinyCNV(img_size=img_size, channels=channels, weight_bits=wbits, act_bits=abits).to(device)

    if resume_path is not None:
        print(f"Resuming from checkpoint: {resume_path}")
        model.load_state_dict(torch.load(resume_path, map_location=device))

    criterion = nn.CrossEntropyLoss().to(device)
    optimizer = torch.optim.Adam(model.parameters(), lr=lr)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=epochs, eta_min=1e-5)

    os.makedirs("models", exist_ok=True)
    channel_str = "x".join(map(str, channels))
    model_name = f"gtsrb_{img_size}x{img_size}_w{wbits}a{abits}_c{channel_str}"
    save_path = f"models/{model_name}.pt"

    best_val_acc = 0.0
    for epoch in range(epochs):
        model.train()
        for images, labels in train_loader:
            images, labels = images.to(device), labels.to(device)
            out = model(images)
            loss = criterion(out, labels)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

        scheduler.step()

        # evaluate on validation split for checkpointing
        val_acc = evaluate(model, val_loader, device)
        if val_acc > best_val_acc:
            best_val_acc = val_acc
            torch.save(model.state_dict(), save_path)

        current_lr = optimizer.param_groups[0]['lr']
        print(f"Epoch [{epoch+1:02d}/{epochs:02d}] - LR: {current_lr:.6f} - Val Acc: {val_acc:.2f}% (Best Val: {best_val_acc:.2f}%)")

    # evaluate best checkpoint on held-out test set
    model.load_state_dict(torch.load(save_path, map_location=device))
    test_acc = evaluate(model, test_loader, device)
    print(f"\nTraining Complete!")
    print(f"Best Validation Accuracy: {best_val_acc:.2f}%")
    print(f"Held-Out Test Accuracy:  {test_acc:.2f}%")

    # export model with best validation accuracy
    model.eval().cpu()
    dummy_input = torch.randn(1, 3, img_size, img_size)
    onnx_path = f"models/{model_name}.onnx"
    export_qonnx(model, dummy_input, export_path=onnx_path)
    print(f"--> Model with best Validation Accuracy is exported to {onnx_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Quantized model for GTSRB")
    parser.add_argument("--img_size", type=int, nargs='?', default=16, help="Input Image Dimension")
    parser.add_argument("--epochs", type=int, nargs='?', default=100, help="Number of Epochs")
    parser.add_argument("--lr", type=float, nargs='?', default=0.003, help="Learning rate")
    parser.add_argument("--bsize", type=int, nargs='?', default=256, help="Batchsize")
    parser.add_argument("--wbits", type=int, nargs='?', default=2, help="Weight bit width")
    parser.add_argument("--abits", type=int, nargs='?', default=3, help="Activation bit width")
    parser.add_argument("--channels", type=int, nargs=3, default=[12, 24, 36], help="Channel dimension list e.g. 12 24 36")
    parser.add_argument("--seed", type=int, nargs='?', default=42, help="Random seed")
    parser.add_argument("--resume_path", type=str, nargs='?', default=None, help="Path to checkpoint model to resume from")

    args = parser.parse_args()

    train_and_export(
        img_size=args.img_size,
        epochs=args.epochs,
        lr=args.lr,
        bsize=args.bsize,
        wbits=args.wbits,
        abits=args.abits,
        channels=args.channels,
        seed=args.seed,
        resume_path=args.resume_path
    )
