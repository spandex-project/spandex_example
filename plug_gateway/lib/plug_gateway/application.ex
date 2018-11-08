defmodule PlugGateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {SpandexDatadog.ApiServer, spandex_datadog_options()},
      {Plug.Adapters.Cowboy2, scheme: :http, plug: PlugGateway.Router, options: [port: port()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: (System.get_env("PORT") || "4000") |> String.to_integer

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
