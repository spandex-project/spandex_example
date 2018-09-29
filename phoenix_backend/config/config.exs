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
  url: [host: "localhost"],
  secret_key_base: "J65s1uZmkX7fCuupiOXZBn3CbE67WcfpJ9nC3JETqIgwdaXIUGs9YnSVQtsZT8qw",
  render_errors: [view: PhoenixBackendWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PhoenixBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
