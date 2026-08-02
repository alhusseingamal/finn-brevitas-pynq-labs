#!/usr/bin/env python3
import torch
from torchvision import transforms
import brevitas.export as bo
import numpy as np
import argparse
from timeit import default_timer as timer
from speechcommands_dataset import SpeechCommandsDataset
from torch.nn import Module

from qonnx.core.modelwrapper import ModelWrapper
from qonnx.core.onnx_exec import execute_onnx
from qonnx.transformation.merge_onnx_models import MergeONNXModels
from qonnx.util.cleanup import cleanup_model
from qonnx.transformation.insert_topk import InsertTopK
from qonnx.core.datatype import DataType
#from qonnx.transformation.base import Transformation

import warnings

# FIXME: currently does not work and leads to problems
# This class is required to add the torchvision ToTensor() transformation at the beginning of the model inference
# The model expects it's inputs to be divided by 255
class ToTensor(Module):
    def __init__(self):

        super(ToTensor, self).__init__()
    def forward(self,x):
        x = x / 255
        return x

parser = argparse.ArgumentParser()
parser.add_argument("--model", type=str, nargs="?", default="tfc_1w1a.onnx")
parser.add_argument("--samples", type=int, default=1)
args = parser.parse_args()


#Load test data
data        = np.load("data/kws_test_X.npy")
labels      = np.load("data/kws_test_Y.npy")
#test_set    = SpeechCommandsDataset(data, labels, transform=transforms.Compose([transforms.ToTensor()]))
test_set    = SpeechCommandsDataset(data, labels)

with warnings.catch_warnings():
    warnings.simplefilter("ignore")

    #Tidy up model so it can be used by qonnx
    model = ModelWrapper(args.model)
    model = cleanup_model(model)

    global_inp_name = model.graph.input[0].name
    ishape = model.get_tensor_shape(global_inp_name)
    print("Input shape is {}".format(ishape))

    # preprocessing: torchvision's ToTensor divides uint8 inputs by 255
    #totensor_pyt = ToTensor()
    #chkpt_preproc_name = 'models/totensor.onnx'
    #input_tensor = torch.randn(ishape)
    #bo.export_qonnx(totensor_pyt, input_tensor, chkpt_preproc_name)

    # join preprocessing and core model
    #pre_model = ModelWrapper(chkpt_preproc_name)
    #model = model.transform(MergeONNXModels(pre_model))
    # add input quantization annotation

    global_inp_name = model.graph.input[0].name
    #model.set_tensor_datatype(global_inp_name, DataType["UINT8"])
    model.set_tensor_datatype(global_inp_name, DataType["FLOAT32"])

    # insert TopK node (argmax) and clean up again
    model = model.transform(InsertTopK(k=1))
    model = cleanup_model(model)
    #model = model.transform(RemoveAllowzeroFromReshape())
    #model = model.transform(RemoveTrainmodeFromBatchnorm())
    #model = cleanup_model(model)
    # Save the model for inspection
    model.save(args.model[:-5]+"_post.onnx")

idict = {}
# Variables for measuring the time
total = 0
minTime = np.inf
maxTime = 0
# Number of correct classifications
correct = 0

if args.samples == -1 or args.samples > len(test_set.data):
    num_samples = len(test_set.data)
else:
    num_samples = args.samples
# go through the amount of selected samples of the dataset and measure the time
for sample in range(num_samples):
    idict["global_in"] = (test_set.data[sample].reshape(ishape).astype("float32") / 255.0)
    start = timer()
    odict = execute_onnx(model, idict)
    end = timer()
    total += end - start
    
    # Update minimum and maximum time
    if (end-start) < minTime:
        minTime = (end-start)
    if (end-start > maxTime):
        maxTime = (end-start)
    
    # Count correct classifications
    correct += odict["global_out"].flatten()[0] == test_set.labels[sample]

print("Test accuracy: {:.2f}%".format(correct/num_samples*100))
print("Inference of {} samples took {:.2f} seconds".format(num_samples, total))
total /= num_samples
print("On average inference took {:.4f} seconds".format(total))
print("The fastest inference took {:.4f} seconds".format(minTime))
print("The slowest inference took {:.4f} seconds".format(maxTime))


