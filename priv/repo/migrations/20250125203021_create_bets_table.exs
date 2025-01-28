defmodule ValueBet.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do

      # Create the enum type
      execute("CREATE TYPE bet_status AS ENUM ('upcoming', 'cancelled', 'won', 'lost');")

      create table(:bets) do
        add :fixture, :string, null: false
        add :bet_amount, :integer, null: false
        add :odds, :decimal, precision: 10, scale: 2
        add :selection_choice, :string, null: false
        add :selected_winner, :string, null: false
        add :actual_winner, :string
        add :bet_status, :bet_status, default: "upcoming", null: false
        add :bet_code, :string, null: false
        add :user_id, references(:users, on_delete: :delete_all), null: false
        add :deleted_at, :utc_datetime, null: true

        timestamps()
      end

      create index(:bets, [:user_id])
  end

  def down do
    # Drop the bets table
    drop table(:bets)

    # Drop the enum type
    execute("DROP TYPE bet_status;")
  end
end
