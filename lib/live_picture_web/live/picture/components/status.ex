defmodule LivePictureWeb.Components.Status do
  @moduledoc false

  use Phoenix.Component

  def content(assigns) do
    ~H"""
    <%= cond do %>
      <% @status in [:uploaded, :processed] -> %>
        <p class="inline-block bg-green-400 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 text-base">
          {@status}
        </p>
      <% @status in [:uploading, :processing] -> %>
        <p class="inline-block bg-yellow-400 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 text-base">
          {@status}
        </p>
      <% true -> %>
        <p class="inline-block bg-gray-400 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 text-base">
          {@status}
        </p>
    <% end %>
    """
  end
end
