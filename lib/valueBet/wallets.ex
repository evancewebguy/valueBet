defmodule ValueBet.Wallets do
  @moduledoc """
  The Wallets context.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo

  alias ValueBet.Wallets.Wallet


    @doc """
  Credits the specified amount to the user's wallet.

  ## Parameters:
    - `user_id`: The ID of the user whose wallet is being credited.
    - `amount`: The amount to credit to the wallet.

  ## Returns:
    - Updated wallet struct.
  """
  def credit_user(user_id, amount) do
    wallet = Repo.get_by!(Wallet, user_id: user_id)

    changeset =
      wallet
      |> Ecto.Changeset.change(amount: wallet.amount + amount)

    Repo.update!(changeset)
  end

  @doc """
  Debits the specified amount from the user's wallet.

  ## Parameters:
    - `user_id`: The ID of the user whose wallet is being debited.
    - `amount`: The amount to debit from the wallet.

  ## Returns:
    - Updated wallet struct.

  ## Raises:
    - `Ecto.InvalidChangesetError` if the wallet does not have sufficient balance.
  """
  def debit_user(user_id, amount) do
    wallet = Repo.get_by!(Wallet, user_id: user_id)

    if wallet.amount < amount do
      raise "Insufficient balance"
    end

    changeset =
      wallet
      |> Ecto.Changeset.change(amount: wallet.amount - amount)

    Repo.update!(changeset)
  end

  @doc """
  Retrieves the current balance of the user's wallet.

  ## Parameters:
    - `user_id`: The ID of the user.

  ## Returns:
    - The current balance as an integer.
  """
  def get_balance(user_id) do
    wallet = Repo.get_by!(Wallet, user_id: user_id)
    wallet.amount
  end
end


