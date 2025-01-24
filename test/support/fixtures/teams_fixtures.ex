defmodule ValueBet.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Teams` context.
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
      |> ValueBet.Teams.create_team()

    team
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> ValueBet.Teams.create_team()

    team
  end
end
