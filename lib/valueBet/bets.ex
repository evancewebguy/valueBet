defmodule ValueBet.Bets do
  @moduledoc """
  The Bets context.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo

  alias ValueBet.Bets.Bet

  @doc """
  Returns the list of bets.

  ## Examples

      iex> list_bets()
      [%Bet{}, ...]

  """
  def list_bets do
    Repo.all(Bet)
  end

  @doc """
  Gets a single bet.

  Raises `Ecto.NoResultsError` if the Bet does not exist.

  ## Examples

      iex> get_bet!(123)
      %Bet{}

      iex> get_bet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bet!(id), do: Repo.get!(Bet, id)

  @doc """
  Creates a bet.

  ## Examples

      iex> create_bet(%{field: value})
      {:ok, %Bet{}}

      iex> create_bet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bet(attrs \\ %{}) do
    %Bet{}
    |> Bet.changeset(attrs)
    |> Repo.insert()
  end


  


  @doc """
  Updates a bet.

  ## Examples

      iex> update_bet(bet, %{field: new_value})
      {:ok, %Bet{}}

      iex> update_bet(bet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bet(%Bet{} = bet, attrs) do
    bet
    |> Bet.changeset(attrs)
    |> Repo.update()
  end


  def save_bets(socket, bets) do
    # Prepare the data for insertion
    bets_data =
      Enum.map(bets, fn bet ->
        %{
          fixture: bet[:fixture],
          odds: Decimal.new(bet[:odds]), # Convert odds to a Decimal if necessary
          selection: bet[:selection],
          winner: bet[:winner],
          inserted_at: NaiveDateTime.utc_now(), # Add timestamps
          updated_at: NaiveDateTime.utc_now()
        }
      end)

    # Insert the data into the bets table
    case Repo.insert_all("bets", bets_data) do
      {:ok, _} ->
        IO.puts("Bets successfully saved.")
        {:noreply, socket}

      {:error, reason} ->
        IO.inspect(reason, label: "Failed to save bets")
        {:noreply, socket}
    end
  end


  @doc """
  Deletes a bet.

  ## Examples

      iex> delete_bet(bet)
      {:ok, %Bet{}}

      iex> delete_bet(bet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bet(%Bet{} = bet) do
    Repo.delete(bet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bet changes.

  ## Examples

      iex> change_bet(bet)
      %Ecto.Changeset{data: %Bet{}}

  """
  def change_bet(%Bet{} = bet, attrs \\ %{}) do
    Bet.changeset(bet, attrs)
  end
end
