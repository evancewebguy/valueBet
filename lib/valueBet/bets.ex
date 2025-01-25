defmodule ValueBet.Bets do
  @moduledoc """
  The Bets context.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo

  alias ValueBet.Bets.Bet


  # Fetch the bet by ID
  bet = Repo.get!(Bet, bet_id)

  # Update the actual_winner field with the event result
  updated_bet =
    bet
    |> Bet.changeset(%{actual_winner: "Arsenal"})
    |> Repo.update!()

  # Determine bet status and calculate winnings or losses
  case Bet.determine_bet_status(updated_bet) do
    %{bet_status: "won"} = bet ->
      winnings = Bet.calculate_winnings(bet)

      # Credit user's wallet (pseudo-code)
      Wallet.credit_user(bet.user_id, winnings)

      # Update the bet status to "won"
      Repo.update!(Bet.changeset(bet, %{bet_status: "won"}))

    %{bet_status: "lost"} = bet ->
      loss = Bet.calculate_loss(bet)

      # Update the bet status to "lost"
      Repo.update!(Bet.changeset(bet, %{bet_status: "lost"}))
  end
end
