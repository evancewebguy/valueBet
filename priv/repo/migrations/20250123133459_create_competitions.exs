defmodule ValueBet.Repo.Migrations.CreateCompetitions do
  use Ecto.Migration

  def change do
    create table(:competitions) do
      add :name, :string
      add :code, :string

      timestamps(type: :utc_datetime)
    end
  end
end
