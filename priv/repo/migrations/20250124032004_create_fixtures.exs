defmodule ValueBet.Repo.Migrations.CreateFixtures do
  use Ecto.Migration

  def change do
    # create table(:fixtures) do
    #   add :fixture_date, :utc_datetime
    #   add :odds_home_win, :decimal
    #   add :odds_away_win, :decimal
    #   add :odds_draw, :decimal
    #   add :status, :string, default: "upcoming"
    #   add :home_team_id, references(:teams, on_delete: :nothing)
    #   add :away_team_id, references(:teams, on_delete: :nothing)
    #   add :competition_id, references(:competitions, on_delete: :nothing)
    #   add :league_id, references(:leagues, on_delete: :nothing)

    #   timestamps(type: :utc_datetime)
    # end

    schema "fixtures" do
      field :fixture_date, :utc_datetime
      field :odds_home_win, :decimal
      field :odds_away_win, :decimal
      field :odds_draw, :decimal
      field :status, :string, default: "upcoming"
      belongs_to :home_team, ValueBet.Team
      belongs_to :away_team, ValueBet.Team
      belongs_to :competition, ValueBet.Competition
      belongs_to :league, ValueBet.League

      timestamps(type: :utc_datetime)
    end

    create index(:fixtures, [:home_team_id])
    create index(:fixtures, [:away_team_id])
    create index(:fixtures, [:competition_id])
    create index(:fixtures, [:league_id])
  end
end
