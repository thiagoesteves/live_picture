defmodule LivePicture.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  alias LivePicture.Models

  @impl true
  def start(_type, _args) do
    children = [
      LivePictureWeb.Telemetry,
      LivePicture.Pictures.Storage,
      LivePicture.Python,
      LivePicture.Models.Supervisor,
      {DNSCluster, query: Application.get_env(:live_picture, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LivePicture.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LivePicture.Finch}
      # Start a worker by calling: LivePicture.Worker.start_link(arg)
      # {LivePicture.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LivePicture.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, _pid} = response ->
        :ok = Models.init()

        # Start to serve requests, typically the last entry
        {:ok, _} = Supervisor.start_child(LivePicture.Supervisor, LivePictureWeb.Endpoint)
        response

      {:error, reason} = response ->
        Logger.error("Error initializing main supervisor reason: #{inspect(reason)}")
        response
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LivePictureWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
