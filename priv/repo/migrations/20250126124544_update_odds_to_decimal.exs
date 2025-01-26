defmodule ValueBet.Repo.Migrations.UpdateOddsToDecimal do
  use Ecto.Migration

  def change do
        alter table(:bets) do
          modify :odds, :decimal, precision: 10, scale: 2
        end
  end
end
