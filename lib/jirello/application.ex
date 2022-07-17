defmodule Jirello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Jirello.Repo,
      # Start the Telemetry supervisor
      JirelloWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Jirello.PubSub},
      # Start the Endpoint (http/https)
      JirelloWeb.Endpoint
      # Start a worker by calling: Jirello.Worker.start_link(arg)
      # {Jirello.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jirello.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JirelloWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
