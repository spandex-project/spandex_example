defmodule PlugGateway.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias PlugGateway.BackendClient

  require Logger

  plug :match
  plug Plug.Telemetry, event_prefix: [:plug_gateway, :router]
  plug Plug.Parsers, parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Hello World")
  end

  get "/flakey" do
    if rem(System.system_time(:second), 2) == 0 do
      send_resp(conn, 200, "Success!")
    else
      send_resp(conn, 500, "Fail!")
    end
  end

  get "/users" do
    BackendClient.get(backend_api_endpoint() <> "/users")
    |> case do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect reason}"}|)
    end
  end

  get "/users/:id" do
    BackendClient.get(backend_api_endpoint() <> "/users/#{id}")
    |> case do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect reason}"}|)
    end
  end

  get "/users_n_plus_1" do
    BackendClient.get(backend_api_endpoint() <> "/users_n_plus_1")
    |> case do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect reason}"}|)
    end
  end

  match _ do
    send_resp(conn, 404, "404: Not Found")
  end

  defp backend_api_endpoint, do: System.get_env("BACKEND_API_URL")

  defp handle_errors(conn, error) do
    Logger.error("Error: #{inspect error[:reason]}")
    meta = Map.put(error, :conn, conn)
    :telemetry.execute([:plug_gateway, :router, :exception], %{}, meta)
    send_resp(conn, conn.status, "Internal Server Error")
  end
end
