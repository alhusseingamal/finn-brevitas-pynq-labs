import onnx
from qonnx.core.modelwrapper import ModelWrapper
from qonnx.transformation.infer_shapes import InferShapes
from qonnx.transformation.general import Cleanup, FoldConstants, RemoveUnusedTensors

# Load model
model = ModelWrapper("./models/tfc-w1a1.onnx")
model = model.transform(InferShapes())
graph = model.graph

# --- 1. Change the graph input shape to [1, 784] ---
inp = graph.input[0]
while len(inp.type.tensor_type.shape.dim) > 0:
    inp.type.tensor_type.shape.dim.pop()
inp.type.tensor_type.shape.dim.add().dim_value = 1
inp.type.tensor_type.shape.dim.add().dim_value = 784
print("Flattened graph input to [1, 784]")

# --- 2. Change ALL intermediate tensors (value_info) from [1, 1, 28, 28] to [1, 784] ---
for vi in graph.value_info:
    dims = [d.dim_value for d in vi.type.tensor_type.shape.dim]
    if dims == [1, 1, 28, 28]:
        while len(vi.type.tensor_type.shape.dim) > 0:
            vi.type.tensor_type.shape.dim.pop()
        vi.type.tensor_type.shape.dim.add().dim_value = 1
        vi.type.tensor_type.shape.dim.add().dim_value = 784
print("Flattened all intermediate 28x28 tensors to [1, 784]")

# --- 3. Remove ALL Reshape and Flatten nodes and rewire them ---
nodes_to_keep = []
removed_nodes = 0

for node in graph.node:
    if node.op_type in ["Reshape", "Flatten"]:
        out_name = node.output[0]
        in_name = node.input[0]
        
        # Rewire any node that consumed the Reshape/Flatten output 
        # to now consume the Reshape/Flatten input directly
        for n2 in graph.node:
            for i, inp_name in enumerate(n2.input):
                if inp_name == out_name:
                    n2.input[i] = in_name
                    
        # Remove the stale value_info for the removed tensor
        new_value_info = [vi for vi in graph.value_info if vi.name != out_name]
        while len(graph.value_info) > 0:
            graph.value_info.pop()
        graph.value_info.extend(new_value_info)
        
        removed_nodes += 1
    else:
        nodes_to_keep.append(node)

# Apply the filtered node list back to the graph
while len(graph.node) > 0:
    graph.node.pop()
graph.node.extend(nodes_to_keep)
print(f"Removed {removed_nodes} Reshape/Flatten nodes.")

# --- 4. Clean up the graph and save ---
model = model.transform(InferShapes())
model = model.transform(FoldConstants())
model = model.transform(RemoveUnusedTensors())
model = model.transform(Cleanup())
model.save("./models/tfc-w1a1-flattened.onnx")
print("Model fully flattened and saved!")
