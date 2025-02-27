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
  def create(_model, onnx_model_path) do
    case File.exists?(onnx_model_path) do
      true ->
        :ok

      false ->
        {_result, _globals} =
          Pythonx.eval(
            """
            import torchvision
            import torch

            from torchvision.models import alexnet, AlexNet_Weights

            net = alexnet(weights=AlexNet_Weights.IMAGENET1K_V1)

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
end
