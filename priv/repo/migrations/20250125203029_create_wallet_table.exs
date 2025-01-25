defmodule ValueBet.Repo.Migrations.CreateWalletTable do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :user_id, references(:users, on_delete: :delete_all), null: false # Foreign key linking to the users table
      add :amount, :integer, null: false, default: 0 # Wallet balance

      timestamps()
    end

    create unique_index(:wallets, [:user_id]) # Ensure each user has only one wallet
  end
end
