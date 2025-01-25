defmodule ValueBet.Wallets.Wallet do
  use Ecto.Schema
  import Ecto.Changeset
  alias ValueBet.Repo

  schema "wallets" do
    field :amount, :integer, default: 0
    belongs_to :user, ValueBet.User

    timestamps()
  end

  @doc false
  def changeset(wallet, attrs) do
    wallet
    |> cast(attrs, [:amount, :user_id])
    |> validate_required([:amount, :user_id])
    |> validate_number(:amount, greater_than_or_equal_to: 0)
  end

end
