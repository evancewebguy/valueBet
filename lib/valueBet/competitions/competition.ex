defmodule ValueBet.Competitions.Competition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "competitions" do
    field :code, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(competition, attrs) do
    competition
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end
end
