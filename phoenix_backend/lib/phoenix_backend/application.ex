defmodule PhoenixBackend.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      worker(SpandexDatadog.ApiServer, [spandex_datadog_options()]),
      # Start the Ecto repository
      supervisor(PhoenixBackend.Repo, []),
      # Start the endpoint when the application starts
      supervisor(PhoenixBackendWeb.Endpoint, []),
      # Start your own worker by calling: PhoenixBackend.Worker.start_link(arg1, arg2, arg3)
      # worker(PhoenixBackend.Worker, [arg1, arg2, arg3]),
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
