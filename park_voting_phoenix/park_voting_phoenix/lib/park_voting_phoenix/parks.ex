defmodule ParkVotingPhoenix.Parks do
  @moduledoc """
  The Parks context.
  """

  import Ecto.Query, warn: false
  alias ParkVotingPhoenix.Repo

  alias ParkVotingPhoenix.Parks.Park
  alias ParkVotingPhoenix.Parks.Vote

  @doc """
  Returns the list of parks sorted by rating descending.
  """
  def list_parks do
    Park
    |> order_by(desc: :rating)
    |> Repo.all()
  end

  @doc """
  Fetches a single park by id.
  Raises `Ecto.NoResultsError` if the Park does not exist.
  """
  def get_park!(id), do: Repo.get!(Park, id)

  @doc """
  Gets two random parks for voting.

  Returns a tuple {park1, park2} or {nil, nil} if not enough parks.
  """
  def get_random_pair do
    # Use the database to pick two random rows instead of loading the whole table
    query =
      from p in Park,
        order_by: fragment("RANDOM()"),
        limit: 2

    case Repo.all(query) do
      [p1, p2] -> {p1, p2}
      _ -> {nil, nil}
    end
  end

  @doc """
  Records a vote between two parks, updates their ELO ratings, and returns the updated parks.
  """
  def record_vote(%Park{id: winner_id, rating: r1} = winner, %Park{id: loser_id, rating: r2} = loser) do
    Repo.transaction(fn ->
      # Insert vote record
      %Vote{}
      |> Vote.changeset(%{winner_id: winner_id, loser_id: loser_id})
      |> Repo.insert!()

      # Calculate new ratings
      {new_r1, new_r2} = ParkVotingPhoenix.Elo.calculate(r1, r2)

      # Update parks
      winner
      |> Park.changeset(%{rating: new_r1})
      |> Repo.update!()

      loser
      |> Park.changeset(%{rating: new_r2})
      |> Repo.update!()
    end)
  end

  @doc """
  Returns the recent votes (most recent first).
  """
  def list_recent_votes(limit \\ 10) do
    Vote
    |> order_by(desc: :inserted_at)
    |> preload([:winner, :loser])
    |> limit(^limit)
    |> Repo.all()
  end

  @doc """
  Returns the rankings (alias for list_parks).
  """
  def list_rankings do
    list_parks()
  end
end
