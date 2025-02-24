defmodule LivePicture.Models do
  @moduledoc """
  The Models context.
  """

  require Logger

  alias LivePicture.Models.Supervisor, as: ModelSup
  alias LivePicture.Models.Worker
  alias LivePicture.Pictures.Picture

  @doc """
  Initialize models
  """
  @spec init() :: :ok
  def init do
    Enum.each(list(), fn model ->
      Logger.info("initializing model: #{model}")
      {:ok, _pid} = create_model(model)
    end)

    :ok
  end

  @doc """
  Create Models
  """
  @spec create_model(atom()) :: {:ok, pid} | {:error, pid(), :already_started}
  def create_model(name), do: ModelSup.start_child(name)

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
  @spec list() :: list()
  def list do
    Ecto.Enum.values(Picture, :model)
  end
end
