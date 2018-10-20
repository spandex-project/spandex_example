# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :phoenix_backend,
  ecto_repos: [PhoenixBackend.Repo]

# Configures the endpoint
config :phoenix_backend, PhoenixBackendWeb.Endpoint,
  instrumenters: [SpandexPhoenix.Instrumenter],
  url: [host: "localhost"],
  render_errors: [view: PhoenixBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger,
  level: :debug,
  utc_log: true

config :logger, :console,
  format: "$dateT$time [$level]$levelpad $metadata $message\n",
  level: :debug,
  metadata: [:request_id, :trace_id, :span_id]

# Configure your database
config :phoenix_backend, PhoenixBackend.Repo,
  adapter: Ecto.Adapters.Postgres,
  loggers: [
    {Ecto.LogEntry, :log, [:info]},
    {SpandexEcto.EctoLogger, :trace, ["phoenix_backend_repo"]}
  ]

config :phoenix_backend, PhoenixBackend.Tracer,
  adapter: SpandexDatadog.Adapter,
  service: :phoenix_backend,
  type: :web

config :spandex, :decorators, tracer: PhoenixBackend.Tracer

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :phoenix_backend_ecto,
  tracer: PhoenixBackend.Tracer,
  otp_app: :phoenix_backend

config :spandex_phoenix, tracer: PhoenixBackend.Tracer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
