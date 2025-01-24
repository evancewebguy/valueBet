defmodule ValueBet.CompetitionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Competitions` context.
  """

  @doc """
  Generate a competition.
  """
  def competition_fixture(attrs \\ %{}) do
    {:ok, competition} =
      attrs
      |> Enum.into(%{
        code: "some code",
        name: "some name"
      })
      |> ValueBet.Competitions.create_competition()

    competition
  end
end
