defmodule PlugGateway.BackendClient do

  alias PlugGateway.Tracer

  def get(url, _opts \\ []) do
    headers =
      [{"authorization", "Bearer #{token()}"}]
      |> Tracer.inject_context()

    :get
    |> Finch.build(url, headers)
    |> Finch.request(MyFinch)
    |> case do
      {:ok, %Finch.Response{status: status, body: body}} -> {:ok, status, body}
      {:error, reason} -> {:error, reason}
    end
  end

  defp token, do: System.get_env("BACKEND_AUTH_TOKEN")
end
