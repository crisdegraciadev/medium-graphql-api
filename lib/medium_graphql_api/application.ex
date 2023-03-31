defmodule MediumGraphqlApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MediumGraphqlApi.Repo,
      # Start the Telemetry supervisor
      MediumGraphqlApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MediumGraphqlApi.PubSub},
      # Start the Endpoint (http/https)
      MediumGraphqlApiWeb.Endpoint
      # Start a worker by calling: MediumGraphqlApi.Worker.start_link(arg)
      # {MediumGraphqlApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MediumGraphqlApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MediumGraphqlApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def name() do
  end
end
