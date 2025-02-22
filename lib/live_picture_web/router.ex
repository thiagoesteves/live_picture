defmodule LivePictureWeb.Router do
  use LivePictureWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LivePictureWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        "default-src 'self' 'unsafe-inline' opshealth.net *.opshealth.net data:;"
    }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivePictureWeb do
    pipe_through :browser

    live "/", PictureLive, :index
    live "/pictures", PictureLive, :index
    live "/pictures/new", PictureLive, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivePictureWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_picture, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LivePictureWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
