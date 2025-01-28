defmodule ValueBet.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string
    field :description, :string
    field :deleted_at, :utc_datetime

    has_many :user_roles, ValueBet.Accounts.UserRole
    has_many :role_permissions, ValueBet.Accounts.RolePermission
    many_to_many :permissions, ValueBet.Accounts.Permission, join_through: ValueBet.Accounts.RolePermission

    timestamps()
  end

  # Correct changeset function for the Role schema
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :description]) # Accept changes for the `name` field
    |> validate_required([:name]) # Ensure `name` is always provided
    |> unique_constraint(:name) # Optional: Enforce unique role names
  end
end
