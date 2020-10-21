defmodule PlugGateway.ContextPropagator do
  @moduledoc """
  Facilitate trace content propagation from Cowboy to Plug. These Telemetry
  callbacks fire in the Cowboy _connection_ process, not the Plug request
  process, so we need to manage an ETS table to allow the request to look up
  the context for its parent connection process.
  """

  use GenServer

  alias PlugGateway.Tracer

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts)

  def span_context() do
    :"$ancestors"
    |> Process.get([])
    |> Enum.find_value(fn pid ->
      case :ets.lookup(__MODULE__, pid) do
        [{_pid, ctx}] -> ctx
        [] -> nil
      end
    end)
  end

  @impl GenServer
  def init(_opts) do
    :ets.new(__MODULE__, [:named_table, :set, :public, read_concurrency: true])

    :telemetry.attach_many(
      "cowboy-propagator",
      [
        [:cowboy, :request, :start],
        [:cowboy, :request, :stop],
        [:cowboy, :request, :exception],
        [:cowboy, :request, :early_error],
      ],
      &__MODULE__.handle_event/4,
      nil
    )

    {:ok, nil}
  end

  def handle_event([:cowboy, :request, :early_error], _meas, meta, _ctx) do
    IO.inspect(meta.req, label: "Cowboy req in :early_error")
    Tracer.start_trace("cowboy.request", http: http_meta(meta.req))
    Tracer.finish_trace()
  end

  def handle_event([:cowboy, :request, :start], _meas, meta, _ctx) do
    IO.inspect(meta.req, label: "Cowboy req in :start")
    Tracer.start_trace("cowboy.request", http: http_meta(meta.req))
    {:ok, ctx} = Tracer.current_context()
    :ets.insert(__MODULE__, {self(), ctx})
  end

  def handle_event([:cowboy, :request, :stop], _meas, meta, _ctx) do
    IO.inspect(meta.req, label: "Cowboy req in :stop")
    Tracer.finish_trace()
    :ets.delete(__MODULE__, self())
  end

  def handle_event([:cowboy, :request, :exception], _meas, meta, _ctx) do
    IO.inspect(meta.req, label: "Cowboy req in :exception")
    Tracer.finish_trace()
    :ets.delete(__MODULE__, self())
  end

  # Reformat Cowboy request metadata into Spandex metadata
  defp http_meta(req) do
    uri = %URI{
      scheme: to_string(req[:scheme]),
      host: req[:host],
      port: req[:port],
      path: req[:path],
      query: req[:qs]
    }

    [
      url: URI.to_string(uri),
      method: req[:method]
    ]
  end
end
