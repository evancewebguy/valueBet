defmodule ValueBet.FixturesTest do
  use ValueBet.DataCase

  alias ValueBet.Fixtures

  describe "fixtures" do
    alias ValueBet.Fixtures.Fixture

    import ValueBet.FixturesFixtures

    @invalid_attrs %{status: nil, fixture_date: nil, odds_home_win: nil, odds_away_win: nil, odds_draw: nil}

    test "list_fixtures/0 returns all fixtures" do
      fixture = fixture_fixture()
      assert Fixtures.list_fixtures() == [fixture]
    end

    test "get_fixture!/1 returns the fixture with given id" do
      fixture = fixture_fixture()
      assert Fixtures.get_fixture!(fixture.id) == fixture
    end

    test "create_fixture/1 with valid data creates a fixture" do
      valid_attrs = %{status: "some status", fixture_date: ~U[2025-01-23 03:20:00Z], odds_home_win: "120.5", odds_away_win: "120.5", odds_draw: "120.5"}

      assert {:ok, %Fixture{} = fixture} = Fixtures.create_fixture(valid_attrs)
      assert fixture.status == "some status"
      assert fixture.fixture_date == ~U[2025-01-23 03:20:00Z]
      assert fixture.odds_home_win == Decimal.new("120.5")
      assert fixture.odds_away_win == Decimal.new("120.5")
      assert fixture.odds_draw == Decimal.new("120.5")
    end

    test "create_fixture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fixtures.create_fixture(@invalid_attrs)
    end

    test "update_fixture/2 with valid data updates the fixture" do
      fixture = fixture_fixture()
      update_attrs = %{status: "some updated status", fixture_date: ~U[2025-01-24 03:20:00Z], odds_home_win: "456.7", odds_away_win: "456.7", odds_draw: "456.7"}

      assert {:ok, %Fixture{} = fixture} = Fixtures.update_fixture(fixture, update_attrs)
      assert fixture.status == "some updated status"
      assert fixture.fixture_date == ~U[2025-01-24 03:20:00Z]
      assert fixture.odds_home_win == Decimal.new("456.7")
      assert fixture.odds_away_win == Decimal.new("456.7")
      assert fixture.odds_draw == Decimal.new("456.7")
    end

    test "update_fixture/2 with invalid data returns error changeset" do
      fixture = fixture_fixture()
      assert {:error, %Ecto.Changeset{}} = Fixtures.update_fixture(fixture, @invalid_attrs)
      assert fixture == Fixtures.get_fixture!(fixture.id)
    end

    test "delete_fixture/1 deletes the fixture" do
      fixture = fixture_fixture()
      assert {:ok, %Fixture{}} = Fixtures.delete_fixture(fixture)
      assert_raise Ecto.NoResultsError, fn -> Fixtures.get_fixture!(fixture.id) end
    end

    test "change_fixture/1 returns a fixture changeset" do
      fixture = fixture_fixture()
      assert %Ecto.Changeset{} = Fixtures.change_fixture(fixture)
    end
  end
end
