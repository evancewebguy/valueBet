defmodule ValueBetWeb.PageController do
  use ValueBetWeb, :controller

  alias ValueBet.Fixtures
  # alias ValueBet.Bets

  def home(conn, _params) do
    # The home page is often custom made,

    current_user = conn.assigns[:current_user]


    # so skip the default app layout.
    fixtures = Enum.map(Fixtures.list_fixtures2(), fn fixture ->
      Map.put(fixture, :odds_home_win, Decimal.to_string(fixture.odds_home_win, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_draw, Decimal.to_string(fixture.odds_draw, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_way_win, Decimal.to_string(fixture.odds_away_win, :normal) |> String.slice(0..4))
    end)

    total_odds = 0
    results = []

    render(conn, :home, current_user: current_user, results: results, fixtures: fixtures, total_odds: total_odds, layout: false)
  end



end
