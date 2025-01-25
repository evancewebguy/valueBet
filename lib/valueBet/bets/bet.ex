defmodule ValueBet.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :bet_amount, :integer
    field :odds, :float
    field :selection_choice, :string
    field :selected_winner, :string
    field :actual_winner, :string
    field :bet_status, :string, default: "pending" # e.g., "won", "lost", "pending"

    timestamps()
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:bet_amount, :odds, :selection_choice, :selected_winner, :actual_winner, :bet_status])
    |> validate_required([:bet_amount, :odds, :selection_choice, :selected_winner])
  end

  def calculate_winnings(%__MODULE__{bet_amount: bet_amount, odds: odds}) do
    bet_amount * odds
  end

  def calculate_loss(%__MODULE__{bet_amount: bet_amount}) do
    bet_amount
  end

  def determine_bet_status(bet) do
    if bet.selected_winner == bet.actual_winner do
      %{bet | bet_status: "won"}
    else
      %{bet | bet_status: "lost"}
    end
  end
end
