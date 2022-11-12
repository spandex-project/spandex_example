defmodule PlugGateway.BackendClient do
  use Spandex.Decorators

  alias PlugGateway.Tracer

  # This tracer should be implied from the app config and I'm not sure why,
  # but it only works when explicitly set here... need to troubleshoot some
  # more.
  @decorate span(tracer: PlugGateway.Tracer)
  def get(url, _opts \\ []) do
    Tracer.update_span(http: [method: "GET", url: url])

    headers =
      [{"authorization", "Bearer #{token()}"}]
      |> Tracer.inject_context()

    :get
    |> Finch.build(url, headers)
    |> Finch.request(MyFinch)
    |> case do
      {:ok, %Finch.Response{status: status, body: body}} ->
        Tracer.update_span(http: [status_code: status])
        {:ok, status, body}

      {:error, reason} ->
        Tracer.span_error(reason, [])
        {:error, reason}
    end
  end

  defp token, do: System.get_env("BACKEND_AUTH_TOKEN")
end
