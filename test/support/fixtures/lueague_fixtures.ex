defmodule ValueBet.LueagueFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Lueague` context.
  """

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ValueBet.Lueague.create_league()

    league
  end
end
