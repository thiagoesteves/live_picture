defmodule LivePictureWeb.Live.CommonFlash do
  @moduledoc false

  @flash_show_time 3000

  # ATTENTION:
  # During the development, adding only a send_after with self() showed not enough
  # since many live components are rendered again and the pid changes.
  # The PubSub is more robust, but it doesn't have a wait time like send_after, so
  # this function will emulate it
  def clear(
        topic,
        pub_sub \\ LivePicture.PubSub,
        event \\ :clear_flash,
        timeout \\ @flash_show_time
      ) do
    Task.start(fn ->
      :timer.sleep(timeout)
      Phoenix.PubSub.broadcast(pub_sub, topic, event)
    end)
  end
end
