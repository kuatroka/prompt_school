defmodule ParkVotingPhoenixWeb.VoteLive do
  use ParkVotingPhoenixWeb, :live_view

  alias ParkVotingPhoenix.Parks

  def mount(_params, _session, socket) do
    parks = Parks.list_parks()
    recent_votes = Parks.list_recent_votes()
    {park1, park2} = Parks.get_random_pair()

    socket =
      socket
      |> assign(:parks, parks)
      |> assign(:recent_votes, recent_votes)
      |> assign(:park1, park1)
      |> assign(:park2, park2)

    {:ok, socket}
  end

  def handle_event("vote", %{"winner" => winner_id, "loser" => loser_id}, socket) do
    winner_id = String.to_integer(winner_id)
    loser_id = String.to_integer(loser_id)

    # Fetch the next pair first so we can update the UI immediately
    {park1, park2} = Parks.get_random_pair()

    # Record the vote asynchronously so the current request returns quickly
    Task.start(fn ->
      winner = Parks.get_park!(winner_id)
      loser = Parks.get_park!(loser_id)
      Parks.record_vote(winner, loser)
    end)

    # Rankings & recent votes may be slightly stale but are refreshed on every click
    parks = Parks.list_rankings()
    recent_votes = Parks.list_recent_votes()

    {:noreply,
     socket
     |> assign(:parks, parks)
     |> assign(:recent_votes, recent_votes)
     |> assign(:park1, park1)
     |> assign(:park2, park2)}
  end
end
