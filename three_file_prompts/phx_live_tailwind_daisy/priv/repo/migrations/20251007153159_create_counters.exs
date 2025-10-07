defmodule PhxLiveTailwindDaisy.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :value, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
