defmodule ParkVotingPhoenix.Repo.Migrations.CreateParks do
  use Ecto.Migration

  def change do
    create table(:parks) do
      add :name, :string, null: false
      add :image_url, :string, null: false
      add :rating, :float, null: false, default: 1200.0

      timestamps()
    end

    create unique_index(:parks, [:name])
  end
end
