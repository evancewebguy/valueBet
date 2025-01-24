defmodule ValueBet.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :fixture, :string, null: false
      add :odds, :decimal, precision: 10, scale: 2, null: false
      add :selection, :string, null: false
      add :winner, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
