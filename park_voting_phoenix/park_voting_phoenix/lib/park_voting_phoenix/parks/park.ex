defmodule ParkVotingPhoenix.Parks.Park do
  use Ecto.Schema
  import Ecto.Changeset

  schema "parks" do
    field :name, :string
    field :image_url, :string
    field :rating, :float, default: 1200.0

    timestamps()
  end

  @doc false
  def changeset(park, attrs) do
    park
    |> cast(attrs, [:name, :image_url, :rating])
    |> validate_required([:name, :image_url])
    |> unique_constraint(:name)
  end
end
