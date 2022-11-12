defmodule PlugGateway.FinchTelemetryHandler do
  @moduledoc "Telemetry callbacks for Finch"

  alias PlugGateway.Tracer

  def install do
    :telemetry.attach_many(
      "finch-telemetry",
      [
        [:finch, :queue, :start],
        [:finch, :queue, :stop],
        [:finch, :queue, :exception],
        [:finch, :connect, :start],
        [:finch, :connect, :stop],
        [:finch, :request, :start],
        [:finch, :request, :stop],
        [:finch, :response, :start],
        [:finch, :response, :stop]
      ],
      &__MODULE__.handle_event/4,
      nil
    )
  end

  # Ignore Finch telemetry for talking to the Datadog Agent, to help avoid
  # looping when TRACING_BATCH_SIZE is set to 1
  def handle_event(_event, _measures, %{port: 8126}, _ctx), do: :noop

  # This span represents Finch getting a connection from the pool
  def handle_event([:finch, :queue, :start], _measures, meta, _ctx) do
    Tracer.start_span("finch.queue", http: http_meta(meta))
  end

  def handle_event([:finch, :queue, :exception], _measures, meta, _ctx) do
    # Finch crashed for some reason while checking out a connection
    exception = Exception.normalize(meta.kind, meta.error, meta.stacktrace)
    Tracer.span_error(exception, meta.stacktrace)
    Tracer.finish_span()
  end

  def handle_event([:finch, :queue, :stop], _measures, _meta, _ctx) do
    Tracer.finish_span()
  end

  # This span represents Finch connecting to the peer
  def handle_event([:finch, :connect, :start], _measures, meta, _ctx) do
    Tracer.start_span("finch.connect", http: http_meta(meta))
  end

  def handle_event([:finch, :connect, :stop], _measures, meta, _ctx) do
    if meta[:error] do
      # This will cause Finch errors such as timeouts to show up as error spans
      Tracer.span_error(meta.error, [])
    end

    Tracer.finish_span()
  end

  # This span represents Finch sending the request
  def handle_event([:finch, :request, :start], _measures, meta, _ctx) do
    Tracer.start_span("finch.request", http: http_meta(meta))
  end

  def handle_event([:finch, :request, :stop], _measures, meta, _ctx) do
    if meta[:error] do
      # This will cause Finch errors such as timeouts to show up as error spans
      Tracer.span_error(meta.error, [])
    end

    Tracer.finish_span()
  end

  # This span represents Finch processing the response
  def handle_event([:finch, :response, :start], _measures, meta, _ctx) do
    Tracer.start_span("finch.response", http: http_meta(meta))
  end

  def handle_event([:finch, :response, :stop], _measures, meta, _ctx) do
    if meta[:error] do
      # This will cause Finch errors such as timeouts to show up as error spans
      Tracer.span_error(meta.error, [])
    end

    Tracer.finish_span()
  end

  # Reformat Finch metadata into Spandex metadata
  defp http_meta(meta) do
    uri = %URI{
      scheme: to_string(meta[:scheme]),
      host: meta[:host],
      port: meta[:port],
      path: meta[:path]
    }

    [
      url: URI.to_string(uri),
      method: meta[:method]
    ]
  end
end
