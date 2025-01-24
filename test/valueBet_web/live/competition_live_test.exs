defmodule ValueBetWeb.CompetitionLiveTest do
  use ValueBetWeb.ConnCase

  import Phoenix.LiveViewTest
  import ValueBet.CompetitionsFixtures

  @create_attrs %{code: "some code", name: "some name"}
  @update_attrs %{code: "some updated code", name: "some updated name"}
  @invalid_attrs %{code: nil, name: nil}

  defp create_competition(_) do
    competition = competition_fixture()
    %{competition: competition}
  end

  describe "Index" do
    setup [:create_competition]

    test "lists all competitions", %{conn: conn, competition: competition} do
      {:ok, _index_live, html} = live(conn, ~p"/competitions")

      assert html =~ "Listing Competitions"
      assert html =~ competition.code
    end

    test "saves new competition", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/competitions")

      assert index_live |> element("a", "New Competition") |> render_click() =~
               "New Competition"

      assert_patch(index_live, ~p"/competitions/new")

      assert index_live
             |> form("#competition-form", competition: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#competition-form", competition: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/competitions")

      html = render(index_live)
      assert html =~ "Competition created successfully"
      assert html =~ "some code"
    end

    test "updates competition in listing", %{conn: conn, competition: competition} do
      {:ok, index_live, _html} = live(conn, ~p"/competitions")

      assert index_live |> element("#competitions-#{competition.id} a", "Edit") |> render_click() =~
               "Edit Competition"

      assert_patch(index_live, ~p"/competitions/#{competition}/edit")

      assert index_live
             |> form("#competition-form", competition: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#competition-form", competition: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/competitions")

      html = render(index_live)
      assert html =~ "Competition updated successfully"
      assert html =~ "some updated code"
    end

    test "deletes competition in listing", %{conn: conn, competition: competition} do
      {:ok, index_live, _html} = live(conn, ~p"/competitions")

      assert index_live |> element("#competitions-#{competition.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#competitions-#{competition.id}")
    end
  end

  describe "Show" do
    setup [:create_competition]

    test "displays competition", %{conn: conn, competition: competition} do
      {:ok, _show_live, html} = live(conn, ~p"/competitions/#{competition}")

      assert html =~ "Show Competition"
      assert html =~ competition.code
    end

    test "updates competition within modal", %{conn: conn, competition: competition} do
      {:ok, show_live, _html} = live(conn, ~p"/competitions/#{competition}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Competition"

      assert_patch(show_live, ~p"/competitions/#{competition}/show/edit")

      assert show_live
             |> form("#competition-form", competition: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#competition-form", competition: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/competitions/#{competition}")

      html = render(show_live)
      assert html =~ "Competition updated successfully"
      assert html =~ "some updated code"
    end
  end
end
