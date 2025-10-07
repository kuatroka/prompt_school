defmodule PhxLiveTailwindDaisy.Counter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counters" do
    field :value, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
