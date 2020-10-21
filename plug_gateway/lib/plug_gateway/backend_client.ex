defmodule PlugGateway.BackendClient do

  def get(url, _opts \\ []) do
    headers = [{"authorization", "Bearer #{token()}"}]

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
