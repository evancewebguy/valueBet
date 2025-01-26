defmodule ValueBet.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do
      create table(:bets) do
        add :bet_amount, :integer, null: false
        add :odds, :float, null: false
        add :selection_choice, :string, null: false
        add :selected_winner, :string, null: false
        add :actual_winner, :string
        add :bet_status, :string, default: "pending", null: false
        add :bet_code, :string, null: false
        add :user_id, references(:users, on_delete: :delete_all), null: false

        timestamps()
      end

      create unique_index(:bets, [:bet_code])
      create index(:bets, [:user_id])
  end
end
