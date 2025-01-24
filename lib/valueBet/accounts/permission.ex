defmodule ValueBet.Accounts.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :name, :string
    field :description, :string

    has_many :role_permissions, ValueBet.Accounts.RolePermission
    many_to_many :roles, ValueBet.Accounts.Role, join_through: ValueBet.Accounts.RolePermission

    timestamps()
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
