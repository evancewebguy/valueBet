defmodule ValueBet.Bets do
  @moduledoc """
  The Bets context for handling bet-related operations.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo
  alias ValueBet.Bets.Bet


  @doc """
  Lists all bets in the system.

  ## Returns:
    - A list of all bets.
  """
  def list_bets do
    Repo.all(Bet)
  end
end
