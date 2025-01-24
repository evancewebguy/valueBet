defmodule ValueBetWeb.LeagueLiveTest do
  use ValueBetWeb.ConnCase

  import Phoenix.LiveViewTest
  import ValueBet.LueagueFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_league(_) do
    league = league_fixture()
    %{league: league}
  end

  describe "Index" do
    setup [:create_league]

    test "lists all leagues", %{conn: conn, league: league} do
      {:ok, _index_live, html} = live(conn, ~p"/leagues")

      assert html =~ "Listing Leagues"
      assert html =~ league.name
    end

    test "saves new league", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("a", "New League") |> render_click() =~
               "New League"

      assert_patch(index_live, ~p"/leagues/new")

      assert index_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#league-form", league: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leagues")

      html = render(index_live)
      assert html =~ "League created successfully"
      assert html =~ "some name"
    end

    test "updates league in listing", %{conn: conn, league: league} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("#leagues-#{league.id} a", "Edit") |> render_click() =~
               "Edit League"

      assert_patch(index_live, ~p"/leagues/#{league}/edit")

      assert index_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#league-form", league: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/leagues")

      html = render(index_live)
      assert html =~ "League updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes league in listing", %{conn: conn, league: league} do
      {:ok, index_live, _html} = live(conn, ~p"/leagues")

      assert index_live |> element("#leagues-#{league.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#leagues-#{league.id}")
    end
  end

  describe "Show" do
    setup [:create_league]

    test "displays league", %{conn: conn, league: league} do
      {:ok, _show_live, html} = live(conn, ~p"/leagues/#{league}")

      assert html =~ "Show League"
      assert html =~ league.name
    end

    test "updates league within modal", %{conn: conn, league: league} do
      {:ok, show_live, _html} = live(conn, ~p"/leagues/#{league}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit League"

      assert_patch(show_live, ~p"/leagues/#{league}/show/edit")

      assert show_live
             |> form("#league-form", league: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#league-form", league: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/leagues/#{league}")

      html = render(show_live)
      assert html =~ "League updated successfully"
      assert html =~ "some updated name"
    end
  end
end
