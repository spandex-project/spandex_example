defmodule PhoenixBackendWeb.Router do
  use PhoenixBackendWeb, :router
  use Spandex.Decorators

  pipeline :api do
    plug :ensure_auth
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixBackendWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]

    get "/users_n_plus_1", UserController, :index_n_plus_1
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: PhoenixBackendWeb.Telemetry
    end
  end

  @decorate span()
  defp ensure_auth(conn, _opts) do
    token =
      conn
      |> get_req_header("authorization")
      |> List.first()
      |> extract_token()

    expected_token = System.get_env("AUTH_TOKEN")

    case token do
      nil ->
        conn
        |> send_resp(401, ~s|{"errors":"Authorization: Bearer <token> header required"}|)
        |> halt()

      ^expected_token ->
        conn

      _ ->
        conn
        |> send_resp(403, ~s|{"errors":"Incorrect authorization token"}|)
        |> halt()
    end
  end

  defp extract_token(nil), do: nil

  defp extract_token(header) do
    header
    |> String.split(" ", parts: 2)
    |> case do
      [type, token] -> extract_token(String.downcase(type), token)
      _ -> nil
    end
  end

  defp extract_token("bearer", token), do: token

  defp extract_token(_, _), do: nil
end
