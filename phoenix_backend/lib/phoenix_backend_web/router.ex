defmodule PhoenixBackendWeb.Router do
  use PhoenixBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixBackendWeb do
    pipe_through :api
  end
end
