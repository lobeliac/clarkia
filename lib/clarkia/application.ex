defmodule Clarkia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClarkiaWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:clarkia, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clarkia.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Clarkia.Finch},
      # Start a worker by calling: Clarkia.Worker.start_link(arg)
      # {Clarkia.Worker, arg},
      # Start to serve requests, typically the last entry
      ClarkiaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clarkia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClarkiaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
