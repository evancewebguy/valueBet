defmodule ValueBet.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :deleted_at, :utc_datetime, null: true

      timestamps(type: :utc_datetime)
    end
  end
end
