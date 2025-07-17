defmodule ParkVotingPhoenixWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    if Mix.env() == :dev do
      attach_performance_logger()
    end

    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ] ++ console_reporter_children()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp console_reporter_children do
    if Application.get_env(:park_voting_phoenix, :env) == :dev do
      [{Telemetry.Metrics.ConsoleReporter, metrics: metrics()}]
    else
      []
    end
  end

  def metrics do
    [
      # Phoenix HTTP Request Metrics (Enhanced for DOM painting visibility)
      summary("phoenix.endpoint.stop.duration",
        tags: [:method, :route],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route, :plug],
        unit: {:native, :millisecond}
      ),

      # LiveView Metrics (Critical for DOM painting performance)
      summary("phoenix.live_view.mount.stop.duration",
        tags: [:view],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.live_view.handle_event.stop.duration",
        tags: [:view, :event],
        unit: {:native, :millisecond}
      ),
      summary("phoenix.live_view.render.stop.duration",
        tags: [:view],
        unit: {:native, :millisecond}
      ),

      # WebSocket/LiveView Connection Metrics
      summary("phoenix.socket_connected.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_joined.duration",
        unit: {:native, :millisecond}
      ),
      summary("phoenix.channel_handled_in.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),

      # Custom VoteLive Performance Metrics (DOM painting bottlenecks)
      summary("vote_live.mount.duration",
        unit: {:native, :millisecond}
      ),
      summary("vote_live.handle_event.duration",
        tags: [:event],
        unit: {:native, :millisecond}
      ),
      summary("vote_live.get_random_pair.duration",
        unit: {:native, :millisecond}
      ),
      summary("vote_live.list_rankings.duration",
        unit: {:native, :millisecond}
      ),
      summary("vote_live.list_recent_votes.duration",
        unit: {:native, :millisecond}
      ),
      summary("vote_live.async_load_rankings.duration",
        unit: {:native, :millisecond}
      ),
      summary("vote_live.async_load_recent_votes.duration",
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      summary("park_voting_phoenix.repo.query.total_time",
        unit: {:native, :millisecond},
        description: "The sum of the other measurements"
      ),
      summary("park_voting_phoenix.repo.query.decode_time",
        unit: {:native, :millisecond},
        description: "The time spent decoding the data received from the database"
      ),
      summary("park_voting_phoenix.repo.query.query_time",
        unit: {:native, :millisecond},
        description: "The time spent executing the query"
      ),
      summary("park_voting_phoenix.repo.query.queue_time",
        unit: {:native, :millisecond},
        description: "The time spent waiting for a database connection"
      ),
      summary("park_voting_phoenix.repo.query.idle_time",
        unit: {:native, :millisecond},
        description:
          "The time the connection spent waiting before being checked out for the query"
      ),

      # VM Metrics
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io")
    ]
  end

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {ParkVotingPhoenixWeb, :count_users, []}
    ]
  end


  defp attach_performance_logger do
    log_file = Path.join("tmp", "performance.log")
    File.mkdir_p!("tmp")

    # Clear previous log and add header
    File.write!(log_file, "=== Performance Log Started at #{DateTime.utc_now()} ===\n")

    # Detach any existing handlers to avoid conflicts
    try do
      :telemetry.detach("performance-logger")
    rescue
      _ -> :ok
    end

    events = [
      [:phoenix, :endpoint, :stop],
      [:phoenix, :router_dispatch, :stop],
      [:phoenix, :live_view, :mount, :stop],
      [:phoenix, :live_view, :handle_event, :stop],
      [:phoenix, :live_view, :render, :stop],
      [:vote_live, :mount],
      [:vote_live, :handle_event],
      [:vote_live, :get_random_pair],
      [:vote_live, :list_rankings],
      [:vote_live, :list_recent_votes],
      [:vote_live, :async_load_rankings],
      [:vote_live, :async_load_recent_votes],
      [:park_voting_phoenix, :repo, :query]
    ]

    :telemetry.attach_many(
      "performance-logger",
      events,
      &handle_performance_event/4,
      %{log_file: log_file}
    )
  end

  defp handle_performance_event(event, measurements, metadata, %{log_file: log_file}) do
    try do
      timestamp = DateTime.utc_now() |> DateTime.to_string()

      log_entry = case event do
        [:phoenix, :endpoint, :stop] ->
          method = get_in(metadata, [:conn, :method]) || "GET"
          path = get_in(metadata, [:conn, :request_path]) || "/"
          "#{timestamp} [HTTP] #{method} #{path} - #{format_duration(measurements[:duration])}"

        [:phoenix, :router_dispatch, :stop] ->
          route = metadata[:route] || "unknown"
          plug = metadata[:plug] || "unknown"
          "#{timestamp} [ROUTER] #{route} #{plug} - #{format_duration(measurements[:duration])}"

        [:phoenix, :live_view, :mount, :stop] ->
          view = get_in(metadata, [:socket, :view]) || "unknown"
          "#{timestamp} [LIVEVIEW] Mount #{view} - #{format_duration(measurements[:duration])}"

        [:phoenix, :live_view, :handle_event, :stop] ->
          event_name = metadata[:event] || "unknown"
          "#{timestamp} [LIVEVIEW] Event #{event_name} - #{format_duration(measurements[:duration])}"

        [:phoenix, :live_view, :render, :stop] ->
          "#{timestamp} [LIVEVIEW] Render - #{format_duration(measurements[:duration])}"

        [:vote_live, :mount] ->
          "#{timestamp} [VOTELIVE] Mount - #{format_duration(measurements[:duration])}"

        [:vote_live, :handle_event] ->
          event_name = metadata[:event] || "unknown"
          "#{timestamp} [VOTELIVE] Event #{event_name} - #{format_duration(measurements[:duration])}"

        [:vote_live, :get_random_pair] ->
          "#{timestamp} [VOTELIVE] Get Random Pair - #{format_duration(measurements[:duration])}"

        [:vote_live, :list_rankings] ->
          "#{timestamp} [VOTELIVE] List Rankings - #{format_duration(measurements[:duration])}"

        [:vote_live, :list_recent_votes] ->
          "#{timestamp} [VOTELIVE] List Recent Votes - #{format_duration(measurements[:duration])}"

        [:vote_live, :async_load_rankings] ->
          "#{timestamp} [VOTELIVE] Async Load Rankings - #{format_duration(measurements[:duration])}"

        [:vote_live, :async_load_recent_votes] ->
          "#{timestamp} [VOTELIVE] Async Load Recent Votes - #{format_duration(measurements[:duration])}"

        [:park_voting_phoenix, :repo, :query] ->
          table = metadata[:source] || "unknown"
          total_time = measurements[:total_time] || 0
          "#{timestamp} [DB] #{table} query - #{format_duration(total_time)}"

        _ ->
          "#{timestamp} [OTHER] #{inspect(event)} - #{inspect(measurements)}"
      end

      # Simple file append - more reliable than File.open!
      File.write!(log_file, log_entry <> "\n", [:append])
    rescue
      error ->
        # Log errors to console if file logging fails
        IO.puts("Performance logging error: #{inspect(error)}")
        IO.puts("Event: #{inspect(event)}")
        IO.puts("Metadata: #{inspect(metadata)}")
    end
  end

  defp format_duration(duration) when is_integer(duration) do
    "#{Float.round(duration / 1_000_000, 1)}ms"
  end
  defp format_duration(_), do: "0ms"
end
