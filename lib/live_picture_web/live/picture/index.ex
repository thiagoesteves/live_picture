defmodule LivePictureWeb.PictureLive do
  use LivePictureWeb, :live_view

  alias LivePicture.Models
  alias LivePicture.Pictures
  alias LivePicture.Pictures.Picture
  alias LivePictureWeb.Components.Status
  alias LivePictureWeb.Live.CommonFlash

  @pub_sub_picture_topic "picture.index"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white text-black rounded min-h-[700px]">
      <div class="ml-2 mr-2">
        <.table_metrics id="pictures" rows={@streams.pictures} h_max_size="h-[700px]">
          <:col :let={{_id, picture}} label="Name">{picture.name}</:col>
          <:col :let={{_id, picture}} label="Image">
            <img src={picture.path} style="width: 60px; height: 60px;" />
          </:col>

          <:col :let={{_id, picture}} label="Model">{String.upcase("#{picture.model}")}</:col>
          <:col :let={{_id, picture}} label="Prediction">{picture.prediction}</:col>
          <:col :let={{_id, picture}} label="Duration (us)">{picture.duration}</:col>
          <:col :let={{_id, picture}} label="Upload">
            <Status.content status={picture.upload_status} />
          </:col>
          <:col :let={{_id, picture}} label="Analysis">
            <Status.content status={picture.analysis_status} />
          </:col>
        </.table_metrics>
      </div>
    </div>

    <.modal
      :if={@live_action in [:new]}
      id="pictures-new-modal"
      show
      on_cancel={JS.patch(~p"/pictures")}
    >
      <.live_component
        module={LivePictureWeb.PictureLive.Components.AddForm}
        id={@picture.id || :new}
        title={@page_title}
        action={@live_action}
        picture={@picture}
        patch={~p"/pictures"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      # Subscrive to receive events for this live component
      Phoenix.PubSub.subscribe(LivePicture.PubSub, @pub_sub_picture_topic)
      # Subscribe to receive Pictures update
      Models.subscribe()
    end

    {:ok, stream(socket, :pictures, Pictures.list_pictures())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info(
        {LivePictureWeb.PictureLive.Components.AddForm, {:saved, picture}},
        socket
      ) do
    CommonFlash.clear(@pub_sub_picture_topic)
    {:noreply, stream_insert(socket, :pictures, picture)}
  end

  def handle_info({:picture_update, picture}, socket) do
    {:noreply, stream_insert(socket, :pictures, picture)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Analysis Results")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Picture Anlysis")
    |> assign(:picture, %Picture{})
  end
end
