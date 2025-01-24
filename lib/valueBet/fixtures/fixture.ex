defmodule ValueBet.Fixtures.Fixture do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fixtures" do
    field :fixture_date, :utc_datetime
    field :odds_home_win, :decimal
    field :odds_away_win, :decimal
    field :odds_draw, :decimal
    field :status, :string
    belongs_to :home_team, ValueBet.Teams.Team
    belongs_to :away_team, ValueBet.Teams.Team
    belongs_to :competition, ValueBet.Competitions.Competition
    belongs_to :league, ValueBet.Lueague.League

    timestamps()
  end

  def changeset(fixture, attrs) do
    fixture
    |> cast(attrs, [:fixture_date, :odds_home_win, :odds_away_win, :odds_draw, :status, :home_team_id, :away_team_id, :competition_id, :league_id])
    |> validate_required([:fixture_date, :home_team_id, :away_team_id, :competition_id, :league_id])
    |> validate_inclusion(:status, ["upcoming", "ongoing", "completed"])
  end
end
