defmodule ValueBet.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string, null: false
      add :description, :string
      add :deleted_at, :utc_datetime, null: true


      timestamps()
    end

    create unique_index(:permissions, [:name])
  end
end
