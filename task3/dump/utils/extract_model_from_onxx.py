import onnx
import numpy as np
import argparse
from onnx import numpy_helper

def describe_tensor(tensor):
    return f"shape={tensor.dims}, dtype={tensor.data_type}"

def extract_initializers(graph):
    return {init.name: init for init in graph.initializer}

def extract_value_info(graph):
    info = {}
    for vi in list(graph.input) + list(graph.output) + list(graph.value_info):
        shape = []
        if vi.type.tensor_type.shape.dim:
            for d in vi.type.tensor_type.shape.dim:
                if d.dim_value > 0:
                    shape.append(d.dim_value)
                else:
                    shape.append("?")
        info[vi.name] = shape
    return info

def describe_node(node, initializers, value_info):
    s = []
    s.append(f"OP: {node.op_type}")
    s.append(f"  name: {node.name if node.name else '(unnamed)'}")
    s.append(f"  inputs: {node.input}")
    s.append(f"  outputs: {node.output}")

    # Shapes
    for inp in node.input:
        if inp in value_info:
            s.append(f"    input {inp} shape: {value_info[inp]}")
    for out in node.output:
        if out in value_info:
            s.append(f"    output {out} shape: {value_info[out]}")

    # Attributes
    if node.attribute:
        s.append("  attributes:")
        for attr in node.attribute:
            if attr.type == 7:  # ints
                s.append(f"    {attr.name}: {attr.ints}")
            elif attr.type == 2:  # int
                s.append(f"    {attr.name}: {attr.i}")
            elif attr.type == 1:  # float
                s.append(f"    {attr.name}: {attr.f}")
            else:
                s.append(f"    {attr.name}: (complex attribute type {attr.type})")

    # Weights
    for inp in node.input:
        if inp in initializers:
            arr = numpy_helper.to_array(initializers[inp])
            s.append(f"  weights for {inp}: shape={arr.shape}")

    return "\n".join(s)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("onnx_path", help="Path to ONNX model")
    parser.add_argument("--out", default="architecture.txt", help="Output file")
    args = parser.parse_args()

    model = onnx.load(args.onnx_path)
    graph = model.graph

    initializers = extract_initializers(graph)
    value_info = extract_value_info(graph)

    lines = []
    lines.append("=== MODEL SUMMARY ===")
    lines.append(f"Inputs: {[i.name for i in graph.input]}")
    lines.append(f"Outputs: {[o.name for o in graph.output]}")
    lines.append("")

    lines.append("=== NODES (Layers) ===")
    for node in graph.node:
        lines.append(describe_node(node, initializers, value_info))
        lines.append("")

    with open(args.out, "w") as f:
        f.write("\n".join(lines))

    print(f"Architecture written to {args.out}")

if __name__ == "__main__":
    main()

