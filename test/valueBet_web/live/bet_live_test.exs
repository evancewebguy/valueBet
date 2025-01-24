defmodule ValueBetWeb.BetLiveTest do
  use ValueBetWeb.ConnCase

  import Phoenix.LiveViewTest
  import ValueBet.BetsFixtures

  @create_attrs %{result: "some result", fixture: "some fixture", odds: "some odds", selection: "some selection", winner: "some winner", user_id: "some user_id", inserted_at: "some inserted_at"}
  @update_attrs %{result: "some updated result", fixture: "some updated fixture", odds: "some updated odds", selection: "some updated selection", winner: "some updated winner", user_id: "some updated user_id", inserted_at: "some updated inserted_at"}
  @invalid_attrs %{result: nil, fixture: nil, odds: nil, selection: nil, winner: nil, user_id: nil, inserted_at: nil}

  defp create_bet(_) do
    bet = bet_fixture()
    %{bet: bet}
  end

  describe "Index" do
    setup [:create_bet]

    test "lists all bets", %{conn: conn, bet: bet} do
      {:ok, _index_live, html} = live(conn, ~p"/bets")

      assert html =~ "Listing Bets"
      assert html =~ bet.result
    end

    test "saves new bet", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("a", "New Bet") |> render_click() =~
               "New Bet"

      assert_patch(index_live, ~p"/bets/new")

      assert index_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet-form", bet: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bets")

      html = render(index_live)
      assert html =~ "Bet created successfully"
      assert html =~ "some result"
    end

    test "updates bet in listing", %{conn: conn, bet: bet} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("#bets-#{bet.id} a", "Edit") |> render_click() =~
               "Edit Bet"

      assert_patch(index_live, ~p"/bets/#{bet}/edit")

      assert index_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet-form", bet: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bets")

      html = render(index_live)
      assert html =~ "Bet updated successfully"
      assert html =~ "some updated result"
    end

    test "deletes bet in listing", %{conn: conn, bet: bet} do
      {:ok, index_live, _html} = live(conn, ~p"/bets")

      assert index_live |> element("#bets-#{bet.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bets-#{bet.id}")
    end
  end

  describe "Show" do
    setup [:create_bet]

    test "displays bet", %{conn: conn, bet: bet} do
      {:ok, _show_live, html} = live(conn, ~p"/bets/#{bet}")

      assert html =~ "Show Bet"
      assert html =~ bet.result
    end

    test "updates bet within modal", %{conn: conn, bet: bet} do
      {:ok, show_live, _html} = live(conn, ~p"/bets/#{bet}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bet"

      assert_patch(show_live, ~p"/bets/#{bet}/show/edit")

      assert show_live
             |> form("#bet-form", bet: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#bet-form", bet: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/bets/#{bet}")

      html = render(show_live)
      assert html =~ "Bet updated successfully"
      assert html =~ "some updated result"
    end
  end
end
