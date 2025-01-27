defmodule ValueBet.Bets do
  @moduledoc """
  The Bets context for handling bet-related operations.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo
  alias ValueBet.Bets.Bet


  @doc """
  Save bets into the database.

  ## Params:
    - bets: List of bets

  ## Returns:
    - The result of the insert operation (ok or error).
  """


# def create_bets(bets) when is_list(bets) do
#   # Insert all bets in one go
#   Repo.insert_all(Bet, bets)
# end
def create_bets(bets) when is_list(bets) do
  # Insert all bets in one go
  case Repo.insert_all(Bet, bets) do
    {count, _} when count > 0 ->
      {:ok, count}  # Return the count of inserted rows if successful
    _ ->
      {:error, "Failed to insert bets"}
  end
end


  @doc """
  Lists all bets in the system.

  ## Returns:
    - A list of all bets.
  """
  def list_bets do
    Repo.all(Bet)
  end


  # Function to list bets by user_id
  def list_bets_for_user(user_id) do
    Bet
    |> where([b], b.user_id == ^user_id)
    |> Repo.all()
  end


  def update_bet_status(bet, status) do
    bet
    |> Bet.changeset(%{bet_status: status})
    |> Repo.update()
  end


  # Retrieves a bet by its ID and raises an error if not found
  def get_bet!(id) do
    Repo.get!(Bet, id)
  end



  def list_bets_with_filters(filters) do
    query = from(b in Bet)

    query =
      Enum.reduce(filters, query, fn
        {"bet_code", value}, query when value != "" ->
          where(query, [b], ilike(b.bet_code, ^"%#{value}%"))

        {"fixture", value}, query when value != "" ->
          where(query, [b], ilike(b.fixture, ^"%#{value}%"))

        {"bet_status", value}, query when value != "" ->
          where(query, [b], b.bet_status == ^value)

        _, query ->
          query
      end)

    Repo.all(query)
  end

end
