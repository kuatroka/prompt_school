defmodule ParkVotingPhoenixWeb.VoteLive do
  use ParkVotingPhoenixWeb, :live_view

  alias ParkVotingPhoenix.Parks

  def mount(_params, _session, socket) do
    start_time = System.monotonic_time()
    
    # Only load essential data for immediate interaction
    {park1, park2} = Parks.get_random_pair()

    socket =
      socket
      |> assign(:park1, park1)
      |> assign(:park2, park2)
      |> assign(:parks, :loading)
      |> assign(:recent_votes, :loading)

    # Load secondary data asynchronously
    send(self(), :load_rankings)
    send(self(), :load_recent_votes)

    :telemetry.execute([:vote_live, :mount], %{duration: System.monotonic_time() - start_time}, %{})
    {:ok, socket}
  end

  def handle_event("vote", %{"winner" => winner_id, "loser" => loser_id}, socket) do
    start_time = System.monotonic_time()
    
    winner_id = String.to_integer(winner_id)
    loser_id = String.to_integer(loser_id)

    # Fetch the next pair first so we can update the UI immediately
    pair_start = System.monotonic_time()
    {park1, park2} = Parks.get_random_pair()
    :telemetry.execute([:vote_live, :get_random_pair], %{duration: System.monotonic_time() - pair_start}, %{})

    # Record the vote asynchronously so the current request returns quickly
    Task.start(fn ->
      winner = Parks.get_park!(winner_id)
      loser = Parks.get_park!(loser_id)
      Parks.record_vote(winner, loser)
    end)

    # Rankings & recent votes may be slightly stale but are refreshed on every click
    rankings_start = System.monotonic_time()
    parks = Parks.list_rankings()
    :telemetry.execute([:vote_live, :list_rankings], %{duration: System.monotonic_time() - rankings_start}, %{})
    
    votes_start = System.monotonic_time()
    recent_votes = Parks.list_recent_votes()
    :telemetry.execute([:vote_live, :list_recent_votes], %{duration: System.monotonic_time() - votes_start}, %{})

    total_duration = System.monotonic_time() - start_time
    :telemetry.execute([:vote_live, :handle_event], %{duration: total_duration}, %{event: "vote"})

    {:noreply,
     socket
     |> assign(:parks, parks)
     |> assign(:recent_votes, recent_votes)
     |> assign(:park1, park1)
     |> assign(:park2, park2)}
  end

  def handle_info(:load_rankings, socket) do
    start_time = System.monotonic_time()
    parks = Parks.list_rankings()
    :telemetry.execute([:vote_live, :async_load_rankings], %{duration: System.monotonic_time() - start_time}, %{})
    
    {:noreply, assign(socket, :parks, parks)}
  end

  def handle_info(:load_recent_votes, socket) do
    start_time = System.monotonic_time()
    recent_votes = Parks.list_recent_votes()
    :telemetry.execute([:vote_live, :async_load_recent_votes], %{duration: System.monotonic_time() - start_time}, %{})
    
    {:noreply, assign(socket, :recent_votes, recent_votes)}
  end
end
