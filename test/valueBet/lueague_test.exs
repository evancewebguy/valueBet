defmodule ValueBet.LueagueTest do
  use ValueBet.DataCase

  alias ValueBet.Lueague

  describe "leagues" do
    alias ValueBet.Lueague.League

    import ValueBet.LueagueFixtures

    @invalid_attrs %{name: nil}

    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Lueague.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id" do
      league = league_fixture()
      assert Lueague.get_league!(league.id) == league
    end

    test "create_league/1 with valid data creates a league" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %League{} = league} = Lueague.create_league(valid_attrs)
      assert league.name == "some name"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lueague.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %League{} = league} = Lueague.update_league(league, update_attrs)
      assert league.name == "some updated name"
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Lueague.update_league(league, @invalid_attrs)
      assert league == Lueague.get_league!(league.id)
    end

    test "delete_league/1 deletes the league" do
      league = league_fixture()
      assert {:ok, %League{}} = Lueague.delete_league(league)
      assert_raise Ecto.NoResultsError, fn -> Lueague.get_league!(league.id) end
    end

    test "change_league/1 returns a league changeset" do
      league = league_fixture()
      assert %Ecto.Changeset{} = Lueague.change_league(league)
    end
  end
end
