defmodule PlugGateway.BackendClient do

  alias PlugGateway.Tracer

  def get(url, opts \\ []) do
    headers =
      [{"authorization", "Bearer #{token()}"}]
      |> Tracer.inject_context()

    url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {:ok, status_code, body}
      {:error, reason} -> {:error, reason}
    end
  end

  defp token, do: System.get_env("BACKEND_AUTH_TOKEN")
end
