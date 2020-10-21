defmodule PlugGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :plug_gateway,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PlugGateway.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.4"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:spandex, "~> 3.0"},
      {:spandex_datadog, "~> 1.0"},
      {:spandex_phoenix, "~> 0.4"},
      {:telemetry, "~> 0.4"}
    ]
  end
end
