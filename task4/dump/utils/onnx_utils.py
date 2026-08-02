import onnx
import os

# ---------------------------------------------------------
# Load an ONNX model
# ---------------------------------------------------------
def load_onnx_model(path):
    """
    Load an ONNX model from a given file path.
    """
    return onnx.load(path)


# ---------------------------------------------------------
# Dump full ONNX protobuf text to a file
# ---------------------------------------------------------
def dump_onnx_to_text(model, out_path="model.txt"):
    """
    Write the full ONNX model (protobuf text format) to a file.
    """
    with open(out_path, "w") as f:
        f.write(str(model))


# ---------------------------------------------------------
# Search for attributes containing a substring (e.g., "signed")
# ---------------------------------------------------------
def find_attributes(model, substring="signed"):
    """
    Print all node attributes whose name contains the given substring.
    """
    substring = substring.lower()
    for node in model.graph.node:
        for attr in node.attribute:
            if substring in attr.name.lower():
                print(f"Node: {node.name} ({node.op_type}) -> {attr.name}: {attr.i}")


# ---------------------------------------------------------
# List op types and domains for a model
# ---------------------------------------------------------
def inspect_ops_and_domains(model):
    """
    Return a list of op types and a set of domains used in the ONNX graph.
    """
    op_types = [n.op_type for n in model.graph.node]
    domains = {n.domain for n in model.graph.node}
    return op_types, domains


# ---------------------------------------------------------
# Inspect multiple ONNX files (like your step_* files)
# ---------------------------------------------------------
def inspect_multiple(files):
    """
    Load and inspect multiple ONNX files, printing op types and domains.
    """
    for stepfile in files:
        if not os.path.exists(stepfile):
            print(f"File not found: {stepfile}")
            continue

        model = load_onnx_model(stepfile)
        op_types, domains = inspect_ops_and_domains(model)

        print(stepfile)
        print(op_types)
        print("domains:", domains)
        print()



def print_model_shape(file):
    model = onnx.load(file)
    graph = model.graph
    for inp in graph.input:
        print("Input name:", inp.name)
        shape = [d.dim_value for d in inp.type.tensor_type.shape.dim]
        print("Shape:", shape)

# Load model
model = load_onnx_model("tmp/gtsrb_12x12_w2a3_c16-32-64.onnx")

# Dump full model
dump_onnx_to_text(model, "model.txt")

# Search for "signed" attributes
find_attributes(model, "signed")

# Inspect step files
inspect_multiple(["step_convert_to_hw.onnx","step_create_dataflow_partition.onnx",])