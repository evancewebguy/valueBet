defmodule ValueBet.Repo.Migrations.CreateBetsTable do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :bet_code, :string, null: false # Unique identifier for the bet
      add :fixture, :string, null: false # Description of the fixture (e.g., "Man United vs Arsenal")
      add :odds, :float, null: false # Odds for the bet
      add :selection_choice, :string, null: false #"Home Win", "Away Win",
      add :selected_winner, :string, null: false # User's predicted winner
      add :actual_winner, :string # Nullable, to be updated after the game outcome
      add :bet_amount, :integer, null: false # Amount placed on the bet
      add :user_id, references(:users, on_delete: :delete_all), null: false # Foreign key linking to the users table

      timestamps()
    end

    create unique_index(:bets, [:bet_id]) # Ensure bet_id is unique
    create index(:bets, [:user_id]) # Index for user_id for efficient lookups
  end
end
