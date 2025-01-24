defmodule ValueBet.Repo.Migrations.DropIndexesFromUserRoles do
  use Ecto.Migration

  def change do
    defmodule ValueBet.Repo.Migrations.DropIndexesFromUserRoles do
      use Ecto.Migration

      def change do
        # Drop the index if it exists
        drop(index(:user_roles, [:user_id, :role_id], name: :user_roles_user_id_role_id_index))
      end
    end

  end
end
