defmodule PlugGateway.Tracer do
  use Spandex.Tracer, otp_app: :plug_gateway

  # This is so that we can send traces using Finch
  def put(url, body, headers) do
    :put
    |> Finch.build("http://" <> url, sanitize_headers(headers), body)
    |> Finch.request(MyFinch)
  end

  # Mint can't handle headers that aren't strings, but Spandex sets the
  # X-Datadog-Trace-Count header as an integer.
  defp sanitize_headers(headers), do: Enum.map(headers, &sanitize_header/1)
  defp sanitize_header({key, value}), do: {to_string(key), to_string(value)}
end
