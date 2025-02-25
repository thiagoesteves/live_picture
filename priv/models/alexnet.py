import torchvision
import torch

from torchvision.models import alexnet, AlexNet_Weights

def build(model_onnx_path):
    net = alexnet(weights=AlexNet_Weights.IMAGENET1K_V1)
    
    if isinstance(model_onnx_path, bytes):
        model_onnx_path = model_onnx_path.decode("utf-8")

    input_names = [ "input" ]
    output_names = [ "output" ]
    
    input_shape = (3, 224, 224)
    batch_size = 1
    dummy_input = torch.randn(batch_size, *input_shape) 
    
    output = torch.onnx.export(net, dummy_input, model_onnx_path, \
                   verbose=False, input_names=input_names, output_names=output_names)
    
    return "Done"