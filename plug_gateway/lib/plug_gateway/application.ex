defmodule PlugGateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Plug.Adapters.Cowboy2, scheme: :http, plug: PlugGateway.Router, options: [port: port()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PlugGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: (System.get_env("PORT") || "4000") |> String.to_integer
end
