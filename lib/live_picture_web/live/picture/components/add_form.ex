defmodule LivePictureWeb.PictureLive.Components.AddForm do
  @moduledoc false

  use LivePictureWeb, :live_component

  alias LivePicture.Models
  alias LivePicture.Pictures
  alias LivePictureWeb.Components.Image
  alias LivePictureWeb.Components.ModelSelection

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
      </.header>

      <.simple_form
        multipart
        for={@form}
        id="picture-add-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Analysis Name (required)" />

        <div
          class="flex flex-col bg-gray-100 items-center justify-center py-4 text-center border border-dashed border-gray-900/25 rounded text-sm leading-6 text-gray-600"
          phx-drop-target={@uploads.picture_file.ref}
        >
          <Image.content image="file" size="medium" />

          <label
            for={@uploads.picture_file.ref}
            class="relative cursor-pointer rounded-md font-semibold text-indigo-600 focus-within:outline-none focus-within:ring-2 focus-within:ring-indigo-600 focus-within:ring-offset-2 hover:text-indigo-500"
          >
            <span>Upload Picture File (.png .jpg .jpeg) </span>
            <.live_file_input upload={@uploads.picture_file} class="sr-only" />
          </label>
          <p class="pl-1">or drag and drop here</p>
        </div>

        <%= for file <- @uploads.picture_file.entries do %>
          <div class="flex items-center">
            <Image.content image="file" size="medium" color="indigo" />
            <progress value={file.progress} max="100" />
            <button
              class="ml-2"
              phx-click="cancel-upload"
              phx-target={@myself}
              phx-value-ref={file.ref}
            >
              <Image.content image="cancel" size="small" color="indigo" />
            </button>
          </div>
        <% end %>
        <h3 class="text-lg font-medium text-gray-900">Choose the model:</h3>
        <ul class="grid grid-cols-5 gap-x-2 w-full">
          <%= for model <- @model.list do %>
            <ModelSelection.content model={model} target={@myself} />
          <% end %>
        </ul>

        <:actions>
          <button
            class={[
              "absolute right-0 mr-4 phx-submit-loading:opacity-75 rounded-lg",
              "bg-gradient-to-tr to-cyan-500 from-blue-500 hover:to-blue-800",
              "py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
            ]}
            phx-disable-with="Starting..."
          >
            Process Picture
          </button>
        </:actions>
      </.simple_form>

      <%= for err <- upload_errors(@uploads.picture_file) do %>
        <p class="alert alert-danger text-red-600">{error_to_string(err)}</p>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    model = ModelSelection.new()
    {:ok, assign(socket, model: model)}
  end

  @impl true
  def update(%{picture: picture} = assigns, socket) do
    changeset =
      picture
      |> Pictures.change_picture(%{model: socket.assigns.model.default.name})

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(:picture_file,
       accept: ~w(.png .jpg .jpeg),
       max_entries: 1,
       max_file_size: 9_000_000,
       auto_upload: true
     )}
  end

  @impl true
  def handle_event("validate", %{"picture" => picture_params}, socket) do
    picture_to_be_checked =
      picture_params
      |> Map.merge(%{"model" => socket.assigns.model.default.name})

    changeset =
      socket.assigns.picture
      |> Pictures.change_picture(picture_to_be_checked)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :picture_file, ref)}
  end

  def handle_event("save", %{"picture" => picture_params}, socket) do
    save_picture(socket, socket.assigns.action, picture_params)
  end

  def handle_event("select-model", %{"model" => name}, socket) do
    model_name = String.to_existing_atom(name)
    model = ModelSelection.select_model(socket.assigns.model, model_name)

    {:noreply, assign(socket, :model, model)}
  end

  defp save_picture(socket, :new, params) do
    [selected_model] =
      socket.assigns.model.list
      |> Enum.filter(fn model -> model.checkbox == "on" end)

    response =
      params_with_file(socket, params)
      |> Map.put("upload_status", :uploaded)
      |> Map.put("model", selected_model.name)
      |> Pictures.create_picture()

    case response do
      {:ok, picture} ->
        notify_parent({:saved, picture})

        # Trigger Image Processing
        Models.process(picture)

        {:noreply,
         socket
         |> put_flash(:info, "Picture created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp params_with_file(socket, params) do
    path =
      socket
      |> consume_uploaded_entries(:picture_file, &upload_static_file/2)
      |> List.first()

    Map.put(params, "path", path)
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp upload_static_file(%{path: path}, entry) do
    filename = Path.basename(path) <> ".#{ext(entry)}"
    dest = Path.join("#{:code.priv_dir(:live_picture)}/static/uploads", filename)
    File.cp!(path, dest)
    {:ok, "/uploads/#{filename}"}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
end
