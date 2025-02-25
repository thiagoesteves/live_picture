defmodule LivePicture.Python do
  @moduledoc """
  Server responsible for handling Python requests.
  """

  use GenServer

  require Logger

  ### ==========================================================================
  ### GenServer Callbacks
  ### ==========================================================================
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    path =
      [:code.priv_dir(:live_picture), "models"]
      |> Path.join()

    case :python.start_link([{:python_path, to_charlist(path)}, {:python, ~c"python3"}]) do
      {:ok, pid} ->
        Logger.info("Initializing Python Server at pid: #{inspect(pid)}")
        {:ok, %{python: pid, path: path}}

      response ->
        response
    end
  end

  @impl true
  def handle_call({:create_onnx, model}, _from, %{python: pid, path: path} = state) do
    output_path = "#{path}/#{model}_model.onnx"
    result = :python.call(pid, model, :build, [output_path])
    {:reply, {:ok, result}, state}
  end

  ### ==========================================================================
  ### Public APIs
  ### ==========================================================================
  def create_model_onnx(model) do
    GenServer.call(__MODULE__, {:create_onnx, model})
  end

  ### ==========================================================================
  ### Private Functions
  ### ==========================================================================
end
