defmodule ValueBet.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Game` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ValueBet.Game.create_team()

    team
  end
end
