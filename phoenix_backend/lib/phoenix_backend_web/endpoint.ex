defmodule PhoenixBackendWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_backend

  socket "/socket", PhoenixBackendWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :phoenix_backend, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_phoenix_backend_key",
    signing_salt: "Ms+026bb"

  plug PhoenixBackendWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    env = System.get_env()

    port = env["PORT"] || config[:port]
    secret_key_base = env["PHOENIX_SECRET"] || config[:secret_key_base]

    config =
      config
      |> Keyword.put(:http, [:inet6, port: port])
      |> Keyword.put(:secret_key_base, secret_key_base)

    {:ok, config}
  end
end
