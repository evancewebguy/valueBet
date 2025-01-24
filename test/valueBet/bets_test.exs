defmodule ValueBet.BetsTest do
  use ValueBet.DataCase

  alias ValueBet.Bets

  describe "bets" do
    alias ValueBet.Bets.Bet

    import ValueBet.BetsFixtures

    @invalid_attrs %{result: nil, fixture: nil, odds: nil, selection: nil, winner: nil, user_id: nil, inserted_at: nil}

    test "list_bets/0 returns all bets" do
      bet = bet_fixture()
      assert Bets.list_bets() == [bet]
    end

    test "get_bet!/1 returns the bet with given id" do
      bet = bet_fixture()
      assert Bets.get_bet!(bet.id) == bet
    end

    test "create_bet/1 with valid data creates a bet" do
      valid_attrs = %{result: "some result", fixture: "some fixture", odds: "some odds", selection: "some selection", winner: "some winner", user_id: "some user_id", inserted_at: "some inserted_at"}

      assert {:ok, %Bet{} = bet} = Bets.create_bet(valid_attrs)
      assert bet.result == "some result"
      assert bet.fixture == "some fixture"
      assert bet.odds == "some odds"
      assert bet.selection == "some selection"
      assert bet.winner == "some winner"
      assert bet.user_id == "some user_id"
      assert bet.inserted_at == "some inserted_at"
    end

    test "create_bet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bets.create_bet(@invalid_attrs)
    end

    test "update_bet/2 with valid data updates the bet" do
      bet = bet_fixture()
      update_attrs = %{result: "some updated result", fixture: "some updated fixture", odds: "some updated odds", selection: "some updated selection", winner: "some updated winner", user_id: "some updated user_id", inserted_at: "some updated inserted_at"}

      assert {:ok, %Bet{} = bet} = Bets.update_bet(bet, update_attrs)
      assert bet.result == "some updated result"
      assert bet.fixture == "some updated fixture"
      assert bet.odds == "some updated odds"
      assert bet.selection == "some updated selection"
      assert bet.winner == "some updated winner"
      assert bet.user_id == "some updated user_id"
      assert bet.inserted_at == "some updated inserted_at"
    end

    test "update_bet/2 with invalid data returns error changeset" do
      bet = bet_fixture()
      assert {:error, %Ecto.Changeset{}} = Bets.update_bet(bet, @invalid_attrs)
      assert bet == Bets.get_bet!(bet.id)
    end

    test "delete_bet/1 deletes the bet" do
      bet = bet_fixture()
      assert {:ok, %Bet{}} = Bets.delete_bet(bet)
      assert_raise Ecto.NoResultsError, fn -> Bets.get_bet!(bet.id) end
    end

    test "change_bet/1 returns a bet changeset" do
      bet = bet_fixture()
      assert %Ecto.Changeset{} = Bets.change_bet(bet)
    end
  end
end
