defmodule ValueBet.Accounts.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "role_permissions" do
    belongs_to :role, ValueBet.Accounts.Role
    belongs_to :permission, ValueBet.Accounts.Permission
    field :deleted_at, :utc_datetime

    timestamps()
  end

  def changeset(role_permission, attrs) do
    role_permission
    |> cast(attrs, [:role_id, :permission_id])
    |> validate_required([:role_id, :permission_id])
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:permission_id)
  end
end
