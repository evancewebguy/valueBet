defmodule ValueBet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ValueBetWeb.Telemetry,
      ValueBet.Repo,
      {DNSCluster, query: Application.get_env(:valueBet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ValueBet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ValueBet.Finch},
      # Start a worker by calling: ValueBet.Worker.start_link(arg)
      # {ValueBet.Worker, arg},
      # Start to serve requests, typically the last entry
      ValueBetWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ValueBet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ValueBetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
