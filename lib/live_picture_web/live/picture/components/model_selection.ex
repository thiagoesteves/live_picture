defmodule LivePictureWeb.Components.ModelSelection do
  @moduledoc false

  use Phoenix.Component

  def content(assigns) do
    ~H"""
    <button
      type="button"
      class={selected_button_class(@model.checkbox)}
      phx-target={@target}
      phx-click="select-model"
      phx-value-model={@model.name}
    >
      <.model_label model={@model} />
    </button>
    """
  end

  def new do
    models =
      Enum.with_index(LivePicture.Models.list(), fn model, index ->
        if index == 0 do
          %{name: model, checkbox: "on"}
        else
          %{name: model, checkbox: "off"}
        end
      end)

    %{list: models, default: hd(models)}
  end

  def select_model(params, model_name) do
    updated_model_list =
      Enum.map(params.list, fn model ->
        case model do
          %{name: ^model_name, checkbox: "on"} -> %{model | checkbox: "off"}
          %{name: ^model_name, checkbox: "off"} -> %{model | checkbox: "on"}
          _ -> model
        end
      end)

    # Check that at least one model has to be selected
    if Enum.find(updated_model_list, &(&1.checkbox == "on")) do
      %{params | list: updated_model_list}
    else
      params
    end
  end

  defp model_label(assigns) do
    ~H"""
    <div class="inline-flex items-center justify-between w-full p-2 text-gray-500 bg-white border-2 border-gray-200 rounded-lg cursor-pointer dark:hover:text-gray-300 dark:border-gray-700 peer-checked:border-blue-600 hover:text-gray-600 dark:peer-checked:text-gray-300 peer-checked:text-gray-600 hover:bg-gray-50 dark:text-gray-400 dark:bg-gray-800 dark:hover:bg-gray-700">
      <div class="w-full font-mono text-xs">{normalize_model_text("#{@model.name}")}</div>
    </div>
    """
  end

  defp normalize_model_text(text) do
    [head | _rest] = String.split(text, "_")
    String.upcase(head)
  end

  defp selected_button_class("on"),
    do: "bg-blue-500 hover:bg-blue-400 py-0.5 px-0.5 border-b-1 hover:border-blue-500 rounded"

  defp selected_button_class("off"), do: "opacity-60"
end
