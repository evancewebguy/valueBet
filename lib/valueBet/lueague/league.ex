defmodule ValueBet.Lueague.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :name, :string
    field :deleted_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
