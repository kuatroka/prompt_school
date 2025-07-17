defmodule ParkVotingPhoenixWeb.Telemetry.PerformanceLogger do
  require Logger

  @log_file "tmp/performance.log"

  def init do
    File.mkdir_p!("tmp")
    File.write!(@log_file, "=== Performance Log Started at #{DateTime.utc_now()} ===\n")
  end

  def handle_event([:phoenix, :endpoint, :stop], measurements, metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "HTTP #{metadata.method} #{metadata.request_path} - #{duration_ms}ms - Status: #{metadata.status}\n"
    append_to_log(log_entry)
  end

  def handle_event([:phoenix, :router_dispatch, :stop], measurements, metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "ROUTER #{metadata.route} -> #{metadata.plug} - #{duration_ms}ms\n"
    append_to_log(log_entry)
  end

  def handle_event([:phoenix, :live_view, :mount, :stop], measurements, metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "LIVEVIEW_MOUNT #{metadata.socket.view} - #{duration_ms}ms\n"
    append_to_log(log_entry)
  end

  def handle_event([:phoenix, :live_view, :handle_event, :stop], measurements, metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "LIVEVIEW_EVENT #{metadata.event} in #{metadata.socket.view} - #{duration_ms}ms\n"
    append_to_log(log_entry)
  end

  def handle_event([:phoenix, :live_view, :render, :stop], measurements, metadata, _config) do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "LIVEVIEW_RENDER #{metadata.socket.view} - #{duration_ms}ms\n"
    append_to_log(log_entry)
  end

  def handle_event([:vote_live, operation], measurements, _metadata, _config) when operation in [:mount, :handle_event, :get_random_pair, :list_rankings, :list_recent_votes, :async_load_rankings, :async_load_recent_votes] do
    duration_ms = System.convert_time_unit(measurements.duration, :native, :millisecond)
    
    log_entry = "VOTE_LIVE_#{String.upcase(to_string(operation))} - #{duration_ms}ms\n"
    append_to_log(log_entry)
  end

  def handle_event([:park_voting_phoenix, :repo, :query], measurements, metadata, _config) do
    total_time_ms = System.convert_time_unit(measurements.total_time, :native, :millisecond)
    query_time_ms = System.convert_time_unit(measurements.query_time, :native, :millisecond)
    queue_time_ms = System.convert_time_unit(measurements.queue_time, :native, :millisecond)
    
    source = metadata.source || "unknown"
    log_entry = "DB_QUERY #{source} - Total: #{total_time_ms}ms (Query: #{query_time_ms}ms, Queue: #{queue_time_ms}ms)\n"
    append_to_log(log_entry)
  end

  def handle_event(_event, _measurements, _metadata, _config) do
    :ok
  end

  defp append_to_log(entry) do
    timestamp = DateTime.utc_now() |> DateTime.to_string()
    File.write!(@log_file, "[#{timestamp}] #{entry}", [:append])
  end
end
