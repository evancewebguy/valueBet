defmodule ValueBet.FixturesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Fixtures` context.
  """

  @doc """
  Generate a fixture.
  """
  def fixture_fixture(attrs \\ %{}) do
    {:ok, fixture} =
      attrs
      |> Enum.into(%{
        fixture_date: ~U[2025-01-23 03:20:00Z],
        odds_away_win: "120.5",
        odds_draw: "120.5",
        odds_home_win: "120.5",
        status: "some status"
      })
      |> ValueBet.Fixtures.create_fixture()

    fixture
  end
end
