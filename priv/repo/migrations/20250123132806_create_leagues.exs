defmodule ValueBet.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string

      add :deleted_at, :utc_datetime, null: true


      timestamps(type: :utc_datetime)
    end
  end
end
