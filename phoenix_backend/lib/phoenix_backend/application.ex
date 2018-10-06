defmodule PhoenixBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {SpandexDatadog.ApiServer, spandex_datadog_options()},
      # Start the Ecto repository
      PhoenixBackend.Repo,
      # Start the Telemetry supervisor
      PhoenixBackendWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixBackend.PubSub},
      # Start the Endpoint (http/https)
      PhoenixBackendWeb.Endpoint
      # Start a worker by calling: PhoenixBackend.Worker.start_link(arg)
      # {PhoenixBackend.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp spandex_datadog_options do
    env = System.get_env()
    config = Application.get_all_env(:spandex_datadog)
    [
      host: env["TRACING_HOST"] || config[:host] || "localhost",
      port: String.to_integer(env["TRACING_PORT"] || config[:port] || "8126"),
      batch_size: String.to_integer(env["TRACING_BATCH_SIZE"] || config[:batch_size] || "10"),
      sync_threshold: String.to_integer(env["TRACING_SYNC_THRESHOLD"] || config[:sync_threshold] || "100"),
      http: config[:http] || HTTPoison
    ]
  end
end
