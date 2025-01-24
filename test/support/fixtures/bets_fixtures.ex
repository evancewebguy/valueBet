defmodule ValueBet.BetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Bets` context.
  """

  @doc """
  Generate a bet.
  """
  def bet_fixture(attrs \\ %{}) do
    {:ok, bet} =
      attrs
      |> Enum.into(%{
        fixture: "some fixture",
        inserted_at: "some inserted_at",
        odds: "some odds",
        result: "some result",
        selection: "some selection",
        user_id: "some user_id",
        winner: "some winner"
      })
      |> ValueBet.Bets.create_bet()

    bet
  end
end
