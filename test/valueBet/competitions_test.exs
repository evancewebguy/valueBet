defmodule ValueBet.CompetitionsTest do
  use ValueBet.DataCase

  alias ValueBet.Competitions

  describe "competitions" do
    alias ValueBet.Competitions.Competition

    import ValueBet.CompetitionsFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_competitions/0 returns all competitions" do
      competition = competition_fixture()
      assert Competitions.list_competitions() == [competition]
    end

    test "get_competition!/1 returns the competition with given id" do
      competition = competition_fixture()
      assert Competitions.get_competition!(competition.id) == competition
    end

    test "create_competition/1 with valid data creates a competition" do
      valid_attrs = %{code: "some code", name: "some name"}

      assert {:ok, %Competition{} = competition} = Competitions.create_competition(valid_attrs)
      assert competition.code == "some code"
      assert competition.name == "some name"
    end

    test "create_competition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Competitions.create_competition(@invalid_attrs)
    end

    test "update_competition/2 with valid data updates the competition" do
      competition = competition_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name"}

      assert {:ok, %Competition{} = competition} = Competitions.update_competition(competition, update_attrs)
      assert competition.code == "some updated code"
      assert competition.name == "some updated name"
    end

    test "update_competition/2 with invalid data returns error changeset" do
      competition = competition_fixture()
      assert {:error, %Ecto.Changeset{}} = Competitions.update_competition(competition, @invalid_attrs)
      assert competition == Competitions.get_competition!(competition.id)
    end

    test "delete_competition/1 deletes the competition" do
      competition = competition_fixture()
      assert {:ok, %Competition{}} = Competitions.delete_competition(competition)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_competition!(competition.id) end
    end

    test "change_competition/1 returns a competition changeset" do
      competition = competition_fixture()
      assert %Ecto.Changeset{} = Competitions.change_competition(competition)
    end
  end
end
