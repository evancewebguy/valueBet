defmodule ValueBet.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :bet_id, references(:bets, on_delete: :delete_all), null: false # Foreign key linking to the bets table
      add :bet_code, :string, null: false # Unique identifier for the bet
      add :amount, :integer, null: false # Amount for the transaction
      add :transaction_type, :string, null: false # E.g., "debit" or "credit"
      add :deleted_at, :utc_datetime, null: true

      timestamps()
    end

    create index(:transactions, [:bet_id]) # Index for faster lookups by bet_id
  end
end
