defmodule PhxLiveTailwindDaisy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxLiveTailwindDaisyWeb.Telemetry,
      PhxLiveTailwindDaisy.Repo,
      {DNSCluster, query: Application.get_env(:phx_live_tailwind_daisy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxLiveTailwindDaisy.PubSub},
      # Start a worker by calling: PhxLiveTailwindDaisy.Worker.start_link(arg)
      # {PhxLiveTailwindDaisy.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxLiveTailwindDaisyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxLiveTailwindDaisy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxLiveTailwindDaisyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
