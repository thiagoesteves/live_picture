defmodule LivePicture.Models.Worker do
  @moduledoc """
  Model Workers
  """

  use GenServer

  require Logger

  ### ==========================================================================
  ### GenServer Callbacks
  ### ==========================================================================
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(args) do
    name = Keyword.fetch!(args, :name)
    path = Keyword.fetch!(args, :path)

    {model, params} = AxonOnnx.import(path)

    {:ok, %{model: model, params: params, name: name}}
  end

  @impl true
  def handle_call(_message, _from, state) do
    {:reply, :ok, state}
  end

  ### ==========================================================================
  ### Public APIs
  ### ==========================================================================

  ### ==========================================================================
  ### Private Functions
  ### ==========================================================================
end
