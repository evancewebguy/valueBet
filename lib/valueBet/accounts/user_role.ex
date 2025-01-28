defmodule ValueBet.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    belongs_to :user, ValueBet.Accounts.User
    belongs_to :role, ValueBet.Accounts.Role
    field :deleted_at, :utc_datetime


    timestamps()
  end

  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_id, :role_id])
    |> foreign_key_constraint(:user_id)  # Ensure the user_id exists
    |> foreign_key_constraint(:role_id)  # Ensure the role_id exists
  end
end
