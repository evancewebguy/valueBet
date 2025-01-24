defmodule ValueBet.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ValueBet.Admin` context.
  """

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{

      })
      |> ValueBet.Admin.create_role()

    role
  end
end
