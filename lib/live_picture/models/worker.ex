defmodule LivePicture.Models.Worker do
  @moduledoc """
  Model Workers
  """

  use GenServer

  require Logger

  alias LivePicture.Pictures
  alias LivePicture.Pictures.Picture

  @worker_topic "worker-topic"

  ### ==========================================================================
  ### GenServer Callbacks
  ### ==========================================================================
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    name = Keyword.fetch!(args, :name)
    GenServer.start_link(__MODULE__, args, name: name)
  end

  @impl true
  def init(args) do
    name = Keyword.fetch!(args, :name)
    path = Keyword.fetch!(args, :path)

    classlist =
      [:code.priv_dir(:live_picture), "python", "models", "classlist.json"]
      |> Path.join()
      |> File.read!()
      |> Jason.decode!()

    model = Ortex.load(path)

    {:ok, %{model: model, classlist: classlist, name: name}}
  end

  @impl true
  def handle_cast(
        {:process, %{path: path} = picture},
        %{model: model, classlist: classlist} = state
      ) do
    image_path =
      Path.join([:code.priv_dir(:live_picture), path])

    tensor = build_tensor(image_path)

    {output} = Ortex.run(model, tensor)

    prediction_id =
      output
      |> Nx.backend_transfer()
      |> Nx.argmax()
      |> Nx.to_number()

    prediction = Map.get(classlist, to_string(prediction_id))

    {:ok, updated_picture} =
      Pictures.update_picture(picture, %{prediction: prediction}, [:prediction])

    Phoenix.PubSub.broadcast(
      LivePicture.PubSub,
      @worker_topic,
      {:picture_update, updated_picture}
    )

    {:noreply, state}
  end

  ### ==========================================================================
  ### Public APIs
  ### ==========================================================================
  @spec process(Picture.t()) :: :ok
  def process(%{model: model} = picture) do
    GenServer.cast(model, {:process, picture})
  end

  def subscribe do
    Phoenix.PubSub.subscribe(LivePicture.PubSub, @worker_topic)
  end

  ### ==========================================================================
  ### Private Functions
  ### ==========================================================================
  defp build_tensor(path_to_image) do
    {:ok, buffer} = File.read(path_to_image)
    {:ok, image} = StbImage.read_binary(buffer)
    image = StbImage.resize(image, 224, 224)
    nx_image = StbImage.to_nx(image)
    nx_channels = Nx.axis_size(nx_image, 2)

    case nx_channels do
      3 -> nx_image
      4 -> Nx.slice(nx_image, [0, 0, 0], [224, 224, 3])
    end
    |> Nx.divide(255)
    |> Nx.subtract(Nx.tensor([0.485, 0.456, 0.406]))
    |> Nx.divide(Nx.tensor([0.229, 0.224, 0.225]))
    |> Nx.transpose()
    |> Nx.new_axis(0)
  end
end
