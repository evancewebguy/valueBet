
defmodule ValueBet.Accounts.UserPermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_permissions" do
    belongs_to :user, ValueBet.Accounts.User
    belongs_to :permission, ValueBet.Accounts.Permission
    field :deleted_at, :utc_datetime


    timestamps()
  end

  @doc false
  def changeset(user_permission, attrs) do
    user_permission
    |> cast(attrs, [:user_id, :permission_id])
    |> validate_required([:user_id, :permission_id])
    |> foreign_key_constraint(:permission_id)
    |> foreign_key_constraint(:user_id)
  end
end
