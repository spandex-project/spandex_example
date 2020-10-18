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
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
