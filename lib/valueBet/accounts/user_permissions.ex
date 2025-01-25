
defmodule ValueBet.Accounts.UserPermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_permissions" do
    belongs_to :user, ValueBet.Accounts.User
    belongs_to :permission, ValueBet.Accounts.Permission


    timestamps()
  end

  @doc false
  def changeset(user_permission, attrs) do
    user_permission
    |> cast(attrs, [:user_id, :permission_id])
    |> validate_required([:user_id, :permission_id])
    |> unique_constraint([:user_id, :permission_id])
    |> foreign_key_constraint(:permission_id, name: "user_permissions_permission_id_fkey")
    |> foreign_key_constraint(:user_id, name: "user_permissions_user_id_fkey")
  end
end
