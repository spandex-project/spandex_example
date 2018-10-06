# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phoenix_backend,
  ecto_repos: [PhoenixBackend.Repo]

# Configures the endpoint
config :phoenix_backend, PhoenixBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KVWJjSFfRVxutdw/H1YAvhAxre5DH58jOC3HVUf5hjHAw87tX+wTZ5vv4tZQ+THJ",
  render_errors: [view: PhoenixBackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PhoenixBackend.PubSub,
  live_view: [signing_salt: "52408qm3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :trace_id, :span_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

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

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :phoenix_backend_ecto,
  tracer: PhoenixBackend.Tracer,
  otp_app: :phoenix_backend

config :spandex_phoenix, tracer: PhoenixBackend.Tracer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
