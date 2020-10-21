defmodule PlugGateway.PlugTelemetryHandler do
  @moduledoc "Handles events from Plug.Telemetry"

  alias PlugGateway.Tracer

  def install do
    :telemetry.attach_many(
      "plug-router-telemetry",
      [
        [:plug_gateway, :router, :start],
        [:plug_gateway, :router, :stop],
        [:plug_gateway, :router, :exception]
      ],
      &__MODULE__.handle_event/4,
      nil
    )
  end

  def handle_event([:plug_gateway, :router, :start], _measures, meta, _ctx) do
    IO.inspect(meta, label: "plug.router start meta")
    case PlugGateway.ContextPropagator.span_context() do
      nil -> Tracer.start_trace("plug.router")
      ctx -> Tracer.continue_trace("plug.router", ctx)
    end
  end

  def handle_event([:plug_gateway, :router, :stop], _measures, meta, _ctx) do
    IO.inspect(meta, label: "plug.router stop meta")
    Tracer.finish_trace()
  end

  # Note: this exception event is fired from this app's handle_errors callback
  # via Plug.ErrorHandler. It is not built into the Plug.Telemetry events by
  # default.
  def handle_event([:plug_gateway, :router, :exception], _measures, meta, _ctx) do
    IO.inspect(meta, label: "plug.router exception meta")
    exception = Exception.normalize(meta[:kind], meta[:error], meta[:stack])
    Tracer.span_error(exception, meta[:stack] || [])
    # Note that we don't finish the trace here because after processing the
    # error, we will still send the response and end up firing the `:stop`
    # event.
  end end
