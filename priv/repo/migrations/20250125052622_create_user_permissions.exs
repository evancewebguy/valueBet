defmodule ValueBet.Repo.Migrations.CreateUserPermissions do
  use Ecto.Migration

  def change do
    create table(:user_permissions) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :permission_id, references(:permissions, on_delete: :delete_all), null: false
      add :deleted_at, :utc_datetime, null: true

      timestamps()
    end

    # Ensure uniqueness to prevent duplicate entries
    create unique_index(:user_permissions, [:user_id, :permission_id])
  end
end
