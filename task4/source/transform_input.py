import tempfile
import torch
import torch.nn as nn
from finn.builder.build_dataflow_config import DataflowBuildConfig
from qonnx.core.modelwrapper import ModelWrapper
from qonnx.core.datatype import DataType
from qonnx.transformation.infer_data_layouts import InferDataLayouts
from qonnx.transformation.infer_shapes import InferShapes
from qonnx.transformation.merge_onnx_models import MergeONNXModels
from qonnx.transformation.insert_topk import InsertTopK
from brevitas.export import export_qonnx

class NormPreprocessing(nn.Module):
    def __init__(self):
        super().__init__()
        # we make mean and std (those are known values retrieved from dataset loader script) part of model state exported to ONNX
        # they become fixed at inference time (not trainable parameters)
        self.register_buffer("mean", torch.tensor([0.3337, 0.3064, 0.3171]).view(1, 3, 1, 1))
        self.register_buffer("std", torch.tensor([0.2672, 0.2564, 0.2629]).view(1, 3, 1, 1))

    def forward(self, x):
        x = x / 255.0
        x = (x - self.mean) / self.std
        return x

def step_transform_input(model: ModelWrapper, cfg: DataflowBuildConfig) -> ModelWrapper:
    # retrieve input shape from the QONNX graph
    input_shape = model.get_tensor_shape(model.graph.input[0].name)
    _, c, h, w = input_shape
    dummy_input = torch.randn(1, c, h, w)

    # temporarily export normalization module
    norm_model = NormPreprocessing()
    with tempfile.NamedTemporaryFile(suffix=".onnx", delete=True) as tmp_file:
        prep_path = tmp_file.name
        export_qonnx(norm_model, dummy_input, export_path=prep_path)
        
        prep_model_wrapper = ModelWrapper(prep_path)    # wrap with QONNX ModelWrapper

        # merge preprocessing into the ONNX graph
        model = model.transform(MergeONNXModels(prep_model_wrapper))
        # note: MergeONNXModels inserts the preprocessing graph before the classifier network

    # UINT8 input annotation for DMA direct pixel streaming
    # By marking the input data as UINT8, we tell FINN that inputs are not floats and thus no cpu preprocessing is needed
    # the accelerator connected to the DMA now just reads raw bytes directly and very fast
    input_tensor_name = model.graph.input[0].name
    model.set_tensor_datatype(input_tensor_name, DataType["UINT8"])

    model = model.transform(InsertTopK(k=1))    # append argmax to model so that it is performed in hardware
    # note: InsertTopK is internally implemented in such a way that it appends the Top‑K node after the classifier’s output

    # the following steps are crucial to restore graph shape consistency after two graph-altering transformations were applied
    model = model.transform(InferShapes())      # recomputes tensor shapes
    model = model.transform(InferDataLayouts()) # recomputes tensor layouts (e.g. NCHW or NHWC, etc...)

    return model
