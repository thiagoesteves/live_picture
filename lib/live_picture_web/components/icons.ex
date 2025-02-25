defmodule LivePictureWeb.Components.Icons do
  @moduledoc false
  use Phoenix.Component

  attr :name, :atom, required: true

  def content(assigns) do
    ~H"""
    <%= case @name do %>
      <% :observer -> %>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="flex-shrink-0 w-6 h-6"
        >
          <path stroke="none" d="M0 0h24v24H0z" fill="none" /><path d="M20 18a2 2 0 1 0 -4 0a2 2 0 0 0 4 0z" /><path d="M8 18a2 2 0 1 0 -4 0a2 2 0 0 0 4 0z" /><path d="M8 6a2 2 0 1 0 -4 0a2 2 0 0 0 4 0z" /><path d="M20 6a2 2 0 1 0 -4 0a2 2 0 0 0 4 0z" /><path d="M6 8v8" /><path d="M18 16v-8" /><path d="M8 6h8" /><path d="M16 18h-8" /><path d="M7.5 7.5l9 9" /><path d="M7.5 16.5l9 -9" />
        </svg>
      <% LivePictureWeb.PictureLive -> %>
        <svg
          class="flex-shrink-0 w-5 h-5 mr-4"
          width="24px"
          height="24px"
          viewBox="0 0 512 512"
          xmlns="http://www.w3.org/2000/svg"
          version="1.1"
          fill="currentColor"
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="1.5"
        >
          <g>
            <path
              class="st0"
              d="M332.998,291.918c52.2-71.895,45.941-173.338-18.834-238.123c-71.736-71.728-188.468-71.728-260.195,0
    c-71.746,71.745-71.746,188.458,0,260.204c64.775,64.775,166.218,71.034,238.104,18.844l14.222,14.203l40.916-40.916
    L332.998,291.918z M278.488,278.333c-52.144,52.134-136.699,52.144-188.852,0c-52.152-52.153-52.152-136.717,0-188.861
    c52.154-52.144,136.708-52.144,188.852,0C330.64,141.616,330.64,226.18,278.488,278.333z"
            />
            <path
              class="st0"
              d="M109.303,119.216c-27.078,34.788-29.324,82.646-6.756,119.614c2.142,3.489,6.709,4.603,10.208,2.46
    c3.49-2.142,4.594-6.709,2.462-10.198v0.008c-19.387-31.7-17.45-72.962,5.782-102.771c2.526-3.228,1.946-7.898-1.292-10.405
    C116.48,115.399,111.811,115.979,109.303,119.216z"
            />
            <path
              class="st0"
              d="M501.499,438.591L363.341,315.178l-47.98,47.98l123.403,138.168c12.548,16.234,35.144,13.848,55.447-6.456
    C514.505,474.576,517.743,451.138,501.499,438.591z"
            />
          </g>
        </svg>
    <% end %>
    """
  end
end
