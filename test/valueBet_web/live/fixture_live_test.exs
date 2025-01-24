defmodule ValueBetWeb.FixtureLiveTest do
  use ValueBetWeb.ConnCase

  import Phoenix.LiveViewTest
  import ValueBet.FixturesFixtures

  @create_attrs %{status: "some status", fixture_date: "2025-01-23T03:20:00Z", odds_home_win: "120.5", odds_away_win: "120.5", odds_draw: "120.5"}
  @update_attrs %{status: "some updated status", fixture_date: "2025-01-24T03:20:00Z", odds_home_win: "456.7", odds_away_win: "456.7", odds_draw: "456.7"}
  @invalid_attrs %{status: nil, fixture_date: nil, odds_home_win: nil, odds_away_win: nil, odds_draw: nil}

  defp create_fixture(_) do
    fixture = fixture_fixture()
    %{fixture: fixture}
  end

  describe "Index" do
    setup [:create_fixture]

    test "lists all fixtures", %{conn: conn, fixture: fixture} do
      {:ok, _index_live, html} = live(conn, ~p"/fixtures")

      assert html =~ "Listing Fixtures"
      assert html =~ fixture.status
    end

    test "saves new fixture", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("a", "New Fixture") |> render_click() =~
               "New Fixture"

      assert_patch(index_live, ~p"/fixtures/new")

      assert index_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fixture-form", fixture: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fixtures")

      html = render(index_live)
      assert html =~ "Fixture created successfully"
      assert html =~ "some status"
    end

    test "updates fixture in listing", %{conn: conn, fixture: fixture} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("#fixtures-#{fixture.id} a", "Edit") |> render_click() =~
               "Edit Fixture"

      assert_patch(index_live, ~p"/fixtures/#{fixture}/edit")

      assert index_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#fixture-form", fixture: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/fixtures")

      html = render(index_live)
      assert html =~ "Fixture updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes fixture in listing", %{conn: conn, fixture: fixture} do
      {:ok, index_live, _html} = live(conn, ~p"/fixtures")

      assert index_live |> element("#fixtures-#{fixture.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#fixtures-#{fixture.id}")
    end
  end

  describe "Show" do
    setup [:create_fixture]

    test "displays fixture", %{conn: conn, fixture: fixture} do
      {:ok, _show_live, html} = live(conn, ~p"/fixtures/#{fixture}")

      assert html =~ "Show Fixture"
      assert html =~ fixture.status
    end

    test "updates fixture within modal", %{conn: conn, fixture: fixture} do
      {:ok, show_live, _html} = live(conn, ~p"/fixtures/#{fixture}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Fixture"

      assert_patch(show_live, ~p"/fixtures/#{fixture}/show/edit")

      assert show_live
             |> form("#fixture-form", fixture: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#fixture-form", fixture: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/fixtures/#{fixture}")

      html = render(show_live)
      assert html =~ "Fixture updated successfully"
      assert html =~ "some updated status"
    end
  end
end
