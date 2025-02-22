defmodule LivePictureWeb.Components.ModelSelection do
  @moduledoc false

  use Phoenix.Component

  alias LivePictureWeb.Components.Image

  @models [
    %{name: "model-1", avatar: "vader", url: ""},
    %{name: "model-2", avatar: "vader", url: ""},
    %{name: "model-3", avatar: "vader", url: ""}
  ]

  @default_model hd(@models).name

  def content(assigns) do
    ~H"""
    <li>
      <button
        class={selected_button_class(@model.checkbox)}
        phx-target={@target}
        phx-click="select-model"
        phx-value-model={@model.name}
      >
        <.model_label model={@model} />
      </button>
    </li>
    """
  end

  def new do
    models =
      Enum.map(@models, fn model ->
        if model.name == @default_model do
          Map.merge(model, %{checkbox: "on"})
        else
          Map.merge(model, %{checkbox: "off"})
        end
      end)

    %{list: models, default: hd(@models)}
  end

  def select_model(params, model_name) do
    updated_model_list =
      Enum.map(params.list, fn model ->
        case model.name do
          ^model_name -> %{model | checkbox: "on"}
          _ -> %{model | checkbox: "off"}
        end
      end)

    %{params | list: updated_model_list}
  end

  defp model_label(assigns) do
    ~H"""
    <div class="inline-flex items-center justify-between w-full p-5 text-gray-500 bg-white border-2 border-gray-200 rounded-lg cursor-pointer dark:hover:text-gray-300 dark:border-gray-700 peer-checked:border-blue-600 hover:text-gray-600 dark:peer-checked:text-gray-300 peer-checked:text-gray-600 hover:bg-gray-50 dark:text-gray-400 dark:bg-gray-800 dark:hover:bg-gray-700">
      <div class="block">
        <div class="grid grid-cols-2 content-center">
          <Image.content image={@model.avatar} size="medium" />
          <div class="w-full text-xs">{@model.name}</div>
        </div>
        <a
          href={@model.url}
          class="text-xs text-center text-blue-100 dark:text-blue-500 hover:underline"
        >
          model reference
        </a>
      </div>
    </div>
    """
  end

  defp selected_button_class("on"),
    do: "bg-blue-500 hover:bg-blue-400 py-0.5 px-0.5 border-b-1 hover:border-blue-500 rounded"

  defp selected_button_class("off"), do: "opacity-60"
end
