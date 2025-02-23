defmodule LivePicture.Models.Supervisor do
  @moduledoc """
  This dynamic supervisor is responsible for starting model workers.
  """

  use DynamicSupervisor

  ### ==========================================================================
  ### Supervisor Callbacks
  ### ==========================================================================

  def start_link(args \\ [], opts \\ [name: __MODULE__]) do
    DynamicSupervisor.start_link(__MODULE__, args, opts)
  end

  @impl true
  def init(args) do
    DynamicSupervisor.init(args)
  end

  ### ==========================================================================
  ### Public API functions
  ### ==========================================================================
  def start_child(name) do
    path =
      [:code.priv_dir(:live_picture), "python", "models", "#{name}_model.onnx"]
      |> Path.join()

    args = [name: name, path: path]

    spec = %{
      id: LivePicture.Models.Worker,
      start: {LivePicture.Models.Worker, :start_link, [args]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
