defmodule ValueBet.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :result, :string
    field :fixture, :string
    field :odds, :decimal
    field :selection, :string
    field :winner, :string
    belongs_to :user_id, ValueBet.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:fixture, :odds, :selection, :winner, :user_id, :result])
    |> validate_required([:fixture, :odds, :selection, :winner, :user_id, :result])
  end
end
