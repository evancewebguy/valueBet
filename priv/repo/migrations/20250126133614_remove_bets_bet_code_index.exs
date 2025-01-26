defmodule ValueBet.Repo.Migrations.RemoveBetsBetCodeIndex do
  use Ecto.Migration

  def change do
    # Drop the index on the bet_code column
    drop index(:bets, [:bet_code])
  end
end
