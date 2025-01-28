defmodule ValueBet.Repo.Migrations.CreateFixtures do
  use Ecto.Migration

  def change do
    create table(:fixtures) do
      add :fixture_date, :utc_datetime, null: false
      add :odds_home_win, :decimal, null: false
      add :odds_away_win, :decimal, null: false
      add :odds_draw, :decimal, null: false
      add :status, :string, default: "upcoming", null: false
      add :deleted_at, :utc_datetime, null: true

      # Associations
      # Foreign key associations
      add :home_team_id, references(:teams, on_delete: :nothing), null: false
      add :away_team_id, references(:teams, on_delete: :nothing), null: false
      add :competition_id, references(:competitions, on_delete: :nothing), null: false
      add :league_id, references(:leagues, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    # Indexes for foreign keys
    create index(:fixtures, [:home_team_id])
    create index(:fixtures, [:away_team_id])
    create index(:fixtures, [:competition_id])
    create index(:fixtures, [:league_id])
  end
end
