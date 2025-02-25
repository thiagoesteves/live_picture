defmodule LivePictureWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use LivePictureWeb, :controller` and
  `use LivePictureWeb, :live_view`.
  """
  use LivePictureWeb, :html

  alias LivePictureWeb.Components.Icons
  alias LivePictureWeb.PictureLive

  embed_templates "layouts/*"

  def logo(assigns) do
    ~H"""
    <a href={path(PictureLive)} class="flex" title="Live Picture">
      <h3 class="class ml-2 items-center tracking-tight text-gray-900">
        <span class="block flex text-4xl font-oswald">
          Live
          <span class="text-transparent ml-3 text-4xl font-meaculpa font-bold bg-clip-text bg-gradient-to-tr to-cyan-500 from-blue-600">
            Picture
          </span>
        </span>
      </h3>
    </a>
    """
  end

  def nav(assigns) do
    ~H"""
    <div class="flex items-center justify-between w-full">
      <nav class="flex space-x-1">
        <.link
          :for={page <- [PictureLive, :observer]}
          class={link_class(@socket.view, page)}
          data-shortcut={JS.navigate(path(page))}
          id={"nav-#{page_name(page)}"}
          navigate={path(page)}
          title={"Navigate to #{String.capitalize(page_name(page))}"}
        >
          <Icons.content name={page} />
          {String.upcase(page_name(page))}
        </.link>
      </nav>
      <div class="ml-auto">
      <.link patch={~p"/pictures/new"}>
        <button class={[
          "flex phx-submit-loading:opacity-75 rounded-lg", "
          bg-gradient-to-tr to-cyan-500 from-blue-500 hover:to-blue-800",
          "py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80"
        ]}>
        <Icons.content name={:observer} />
          New Picture Analysis
        </button>
      </.link>
      </div>
    </div>
    """
  end

  def footer(assigns) do
    assigns =
      assign(assigns,
        oss_version: Application.spec(:live_picture, :vsn)
      )

    ~H"""
    <footer class="flex flex-col px-3 py-6 text-sm justify-center items-center md:flex-row">
      <.version name="Live Picture" version={@oss_version} />

      <span class="text-gray-800 dark:text-gray-200 font-semibold">
        Made by
        <a
          href="https://www.linkedin.com/in/thiago-cesar-calori-esteves-972368115/"
          class="font-medium text-blue-600 underline dark:text-blue-500 hover:no-underline"
        >
          Thiago Esteves
        </a>
      </span>
    </footer>
    """
  end

  attr :name, :string
  attr :version, :string

  defp version(assigns) do
    ~H"""
    <span class="text-gray-600 dark:text-gray-400 tabular mr-0 mb-1 md:mr-3 md:mb-0">
      {@name} {if @version, do: "v#{@version}", else: "–"}
    </span>
    """
  end

  defp path(PictureLive), do: "/pictures"
  defp path(:observer), do: "/observer"

  defp page_name(PictureLive), do: "pictures"
  defp page_name(:observer), do: "observer"

  defp link_class(curr, page) do
    base =
      "flex items-center px-4 py-2.5 text-sm font-bold transition-all duration-200 text-gray-900 rounded-lg group"

    if curr == page do
      base <> " bg-gray-100"
    else
      base <> " hover:text-white hover:bg-indigo-500"
    end
  end
end
