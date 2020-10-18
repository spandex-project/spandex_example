defmodule PhoenixBackendWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PhoenixBackendWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PhoenixBackendWeb.ConnCase

      alias PhoenixBackendWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint PhoenixBackendWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PhoenixBackend.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PhoenixBackend.Repo, {:shared, self()})
    end

    expected_token = System.get_env("AUTH_TOKEN")
    conn = Phoenix.ConnTest.build_conn()
           |> Plug.Conn.put_req_header("authorization", "Bearer #{expected_token}")

    {:ok, conn: conn}
  end
end
