defmodule LivePictureWeb.PictureLive do
  use LivePictureWeb, :live_view

  alias LivePicture.Pictures
  alias LivePicture.Pictures.Picture
  alias LivePictureWeb.Components.Status
  alias LivePictureWeb.Live.CommonFlash

  @pub_sub_picture_topic "picture.index"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white rounded" style="min-height: 800px;">
      <.header class="ml-2 mr-2">
        <:actions>
          <.link patch={~p"/pictures/new"}>
            <.button class="mt-1">New Picture Analysis</.button>
          </.link>
        </:actions>
      </.header>

      <div class="ml-2 mr-2">
        <.table id="pictures" rows={@streams.pictures}>
          <:col :let={{_id, picture}} label="Name">{picture.name}</:col>
          <:col :let={{_id, picture}} label="Path">{picture.path}</:col>
          <:col :let={{_id, picture}} label="Model">{picture.model}</:col>
          <:col :let={{_id, picture}} label="Upload Status">
            <Status.content status={picture.upload_status} />
          </:col>
        </.table>
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
    # Subscrive to receive events for this live component
    if connected?(socket) do
      Phoenix.PubSub.subscribe(LivePicture.PubSub, @pub_sub_picture_topic)
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
    IO.puts("hi")
    {:noreply, stream_insert(socket, :pictures, picture)}
  end

  def handle_info({:picture_status_updated, picture}, socket) do
    {:noreply, stream_insert(socket, :pictures, picture)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Picture Analysis")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Picture")
    |> assign(:picture, %Picture{})
  end
end
