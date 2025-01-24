defmodule ValueBet.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :code, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :code])
    |> validate_required([:name, :code])
  end
end
