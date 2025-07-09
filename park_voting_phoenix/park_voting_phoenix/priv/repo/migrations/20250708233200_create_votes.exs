defmodule ParkVotingPhoenix.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :winner_id, references(:parks, on_delete: :delete_all), null: false
      add :loser_id, references(:parks, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:votes, [:winner_id])
    create index(:votes, [:loser_id])
  end
end
