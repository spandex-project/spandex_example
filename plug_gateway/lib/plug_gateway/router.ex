defmodule PlugGateway.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers, parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  plug :dispatch

  get "/" do
    conn = send_resp(conn, 200, "Hello World")
  end

  get "/flakey" do
    if rem(System.system_time(:second), 2) == 0 do
      send_resp(conn, 200, "Success!")
    else
      send_resp(conn, 500, "Fail!")
    end
  end

  match _ do
    send_resp(conn, 404, "404: Not Found")
  end
end
