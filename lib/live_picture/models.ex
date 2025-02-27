defmodule LivePicture.Models do
  @moduledoc """
  The Models context.
  """

  require Logger

  alias LivePicture.Models.Supervisor, as: ModelSup
  alias LivePicture.Models.Worker
  alias LivePicture.Pictures.Picture
  alias LivePicture.Python.Onnx

  @doc """
  Initialize models
  """
  @spec init() :: :ok
  def init do
    # Create model directory if doesn't exist
    File.mkdir_p!(base_onnx_dir())

    :ok = Onnx.init()

    Enum.each(list(), fn model when is_atom(model) ->
      Logger.info("Creating Onnx model for #{model}")
      :ok = Onnx.create(model, onnx_model_path(model))
      Logger.info("initializing server model for #{model}")
      {:ok, _pid} = create_model(model, onnx_model_path(model))
    end)

    :ok
  end

  @doc """
  Create Models
  """
  @spec create_model(atom(), String.t()) :: {:ok, pid} | {:error, pid(), :already_started}
  def create_model(name, onnx_model_path), do: ModelSup.start_child(name, onnx_model_path)

  @doc """
  Subscribe to receive updates
  """
  @spec subscribe() :: :ok
  def subscribe, do: Worker.subscribe()

  @doc """
  Process image with the respective module
  """
  @spec process(Picture.t()) :: :ok
  def process(picture) do
    Worker.process(picture)
  end

  @doc """
  List Models
  """
  @spec list() :: [atom()]
  def list do
    Ecto.Enum.values(Picture, :model)
  end

  defp base_onnx_dir do
    Application.get_env(:live_picture, LivePicture.Models)[:base_onnx_dir]
  end

  defp onnx_model_path(model) do
    "#{base_onnx_dir()}/#{model}_model.onnx"
  end
end
