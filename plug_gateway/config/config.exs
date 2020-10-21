# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :plug_gateway, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:plug_gateway, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :logger,
  level: :debug,
  utc_log: true

config :logger, :console,
  format: "$dateT$time [$level]$levelpad $metadata $message\n",
  level: :debug,
  metadata: [:request_id, :trace_id, :span_id]

config :plug_gateway, PlugGateway.Tracer,
  adapter: SpandexDatadog.Adapter,
  service: :plug_gateway,
  type: :web

config :spandex_phoenix, tracer: PlugGateway.Tracer

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
