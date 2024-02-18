defmodule MultiTenant.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MultiTenantWeb.Telemetry,
      MultiTenant.Repo,
      {DNSCluster, query: Application.get_env(:multi_tenant, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MultiTenant.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MultiTenant.Finch},
      # Start a worker by calling: MultiTenant.Worker.start_link(arg)
      # {MultiTenant.Worker, arg},
      # Start to serve requests, typically the last entry
      MultiTenantWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MultiTenant.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MultiTenantWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
