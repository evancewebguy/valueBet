defmodule ValueBet.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      add :deleted_at, :utc_datetime, null: true

      timestamps()
    end

    create unique_index(:user_roles, [:user_id, :role_id])
  end
end
