defmodule PhoenixBackendWeb.Router do
  use PhoenixBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixBackendWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/posts", PostController, except: [:new, :edit]

    get "/users_n_plus_1", UserController, :index_n_plus_1
  end
end
