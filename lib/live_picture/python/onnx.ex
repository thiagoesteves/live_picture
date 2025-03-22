defmodule LivePicture.Python.Onnx do
  @moduledoc """
  Server responsible for handling Python requests.
  """

  require Logger

  @doc """
  This function initializes the Pythonx
  """
  @spec init() :: :ok
  def init do
    Pythonx.uv_init("""
    [project]
    name = "live_picture"
    version = "0.1.0"
    requires-python = "==3.10.*"
    dependencies = [
      "torch == 2.6.0",
      "torchvision == 0.21",
      "onnx == 1.17.0"
    ]
    """)
  end

  @doc """
  Create Onnx file (if the models doesn't exist) for the respective model
  """
  @spec create(atom(), String.t()) :: :ok
  def create(model, onnx_model_path) do
    case File.exists?(onnx_model_path) do
      true ->
        :ok

      false ->
        model_import_code = get_model_import_code(model)

        {_result, _globals} =
          Pythonx.eval(
            """
            import torchvision
            import torch

            #{model_import_code}

            input_names = [ "input" ]
            output_names = [ "output" ]

            input_shape = (3, 224, 224)
            batch_size = 1
            dummy_input = torch.randn(batch_size, *input_shape) 

            output = torch.onnx.export(net, dummy_input, "#{onnx_model_path}", verbose=False, input_names=input_names, output_names=output_names)
            """,
            %{}
          )

        :ok
    end
  end

  ### ==========================================================================
  ### Private Functions
  ### ==========================================================================

  # Helper function to get the appropriate import code for each model
  defp get_model_import_code(:alexnet) do
    """
    from torchvision.models import alexnet, AlexNet_Weights
    net = alexnet(weights=AlexNet_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:convnext) do
    """
    from torchvision.models import convnext_base, ConvNeXt_Base_Weights
    net = convnext_base(weights=ConvNeXt_Base_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:resnet18) do
    """
    from torchvision.models import resnet18, ResNet18_Weights
    net = resnet18(weights=ResNet18_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:squeezenet) do
    """
    from torchvision.models import squeezenet1_1, SqueezeNet1_1_Weights
    net = squeezenet1_1(weights=SqueezeNet1_1_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:vgg16) do
    """
    from torchvision.models import vgg16, VGG16_Weights
    net = vgg16(weights=VGG16_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:resnet50) do
    """
    from torchvision.models import resnet50, ResNet50_Weights
    net = resnet50(weights=ResNet50_Weights.IMAGENET1K_V2)
    """
  end

  defp get_model_import_code(:densenet121) do
    """
    from torchvision.models import densenet121, DenseNet121_Weights
    net = densenet121(weights=DenseNet121_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:efficientnet) do
    """
    from torchvision.models import efficientnet_b0, EfficientNet_B0_Weights
    net = efficientnet_b0(weights=EfficientNet_B0_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:mobilenet) do
    """
    from torchvision.models import mobilenet_v3_large, MobileNet_V3_Large_Weights
    net = mobilenet_v3_large(weights=MobileNet_V3_Large_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:regnet) do
    """
    from torchvision.models import regnet_y_400mf, RegNet_Y_400MF_Weights
    net = regnet_y_400mf(weights=RegNet_Y_400MF_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:vision_transformer) do
    """
    from torchvision.models import vit_b_16, ViT_B_16_Weights
    net = vit_b_16(weights=ViT_B_16_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:swin_transformer) do
    """
    from torchvision.models import swin_t, Swin_T_Weights
    net = swin_t(weights=Swin_T_Weights.IMAGENET1K_V1)
    """
  end

  defp get_model_import_code(:inception) do
    """
    from torchvision.models import inception_v3, Inception_V3_Weights
    net = inception_v3(weights=Inception_V3_Weights.IMAGENET1K_V1)
    # Note: Inception uses 299x299 images by default, but we're standardizing on 224x224
    """
  end
end
