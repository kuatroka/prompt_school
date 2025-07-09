defmodule ParkVotingPhoenix.Parks.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    belongs_to :winner, ParkVotingPhoenix.Parks.Park, foreign_key: :winner_id
    belongs_to :loser, ParkVotingPhoenix.Parks.Park, foreign_key: :loser_id

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:winner_id, :loser_id])
    |> validate_required([:winner_id, :loser_id])
  end
end
