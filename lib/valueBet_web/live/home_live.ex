defmodule ValueBetWeb.HomeLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Fixtures
  alias ValueBet.Bets

  def render(assigns) do
    ~H"""
      <div class="mx-auto max-w-xl px-4 py-6 sm:px-6 lg:px-8">
        <!-- Selected Results Section -->
        <%= if @results do %>
          <div class="mt-4 bg-white shadow-md p-4">
            <h3 class="font-bold text-lg mb-2">Selected Results</h3>
            <ul>
              <%= for result <- @results do %>
                <li class="py-2 border-b">
                  <p><strong>Fixture:</strong> <%= result.fixture %></p>
                  <p><strong>Selected:</strong> <%= result.selection %></p>
                  <p><strong>Odds:</strong> <%= result.odds %></p>
                </li>
              <% end %>
            </ul>

            <!-- Total Odds -->
            <div class="mt-2">
              <strong>Total Odds:</strong>
                <%= if @total_odds do %>
                  <p>Total Odds: <%= @total_odds %></p>
                <% else %>
                  <p>No odds selected yet</p>
                <% end %>
              </div>
            </div>

            <!-- Place Bet Button -->
          <div class="mt-4">
            <button
              phx-click="place_bet"
              class="px-6 py-2 bg-blue-600 text-white font-medium text-sm rounded-md shadow hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              Place Bet
            </button>
            </div>
        <% end %>

        <div class="mt-2 mx-auto max-w-7xl px-4 py-3 bg-gray-300 flex">
          <div class="w-1/2 px-2"><p><strong>Teams</strong></p></div>
          <div class="w-1/2 px-2 flex">
            <div class="w-1/3 px-2"><p><strong>1</strong></p></div>
            <div class="w-1/3 px-2"><p><strong>x</strong></p></div>
            <div class="w-1/3 px-2"><p><strong>2</strong></p></div>
          </div>
        </div>

        <!-- Fixtures Loop -->
        <%= for fixture <- @fixtures do %>
          <div class="mt-2 mx-auto max-w-7xl px-4 py-3 bg-gray-200 flex flex-col">
            <div class="h-1/2 flex items-center justify-center">
              <div class="w-1/2 px-2"><p class="text-sm font-bold"><%= fixture.league.name %></p></div>
              <div class="w-1/2 px-2 flex justify-end">
                <p class="text-sm font-bold text-left self-start">
                  <%= fixture.fixture_date |> DateTime.to_string() |> String.slice(0..15) %>
                </p>
              </div>
            </div>

            <div class="mt-1 h-1/2 flex items-center justify-center">
              <div class="w-1/2 px-2"><p><%= fixture.home_team.name %> v <%= fixture.away_team.name %></p></div>
              <div class="w-1/2 px-2 flex">
                <!-- Home Win Button -->
                <div class="w-1/3 px-2">
                  <button
                    class="px-4 py-1 bg-gray-500 text-white font-medium text-sm rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
                    phx-click="add_to_results"
                    phx-value-odds={fixture.odds_home_win}
                    phx-value-fixture={"#{fixture.home_team.name} vs #{fixture.away_team.name}"}
                    phx-value-selection="home_win"
                    phx-value-winner={fixture.home_team.id}
                  >
                    <%= Decimal.to_string(fixture.odds_home_win, :normal) |> String.slice(0..4) %>
                  </button>
                </div>

                <!-- Draw Button -->
                <div class="w-1/3 px-2">
                  <button
                    class="px-4 py-1 bg-gray-500 text-white font-medium text-sm rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
                    phx-click="add_to_results"
                    phx-value-odds={fixture.odds_draw}
                    phx-value-fixture={"#{fixture.home_team.name} vs #{fixture.away_team.name}"}
                    phx-value-selection="draw"
                    phx-value-winner="0"
                  >
                    <%= Decimal.to_string(fixture.odds_draw, :normal) |> String.slice(0..4) %>
                  </button>
                </div>

                <!-- Away Win Button -->
                <div class="w-1/3 px-2">
                  <button
                    class="px-4 py-1 bg-gray-500 text-white font-medium text-sm rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
                    phx-click="add_to_results"
                    phx-value-odds={fixture.odds_away_win}
                    phx-value-fixture={"#{fixture.home_team.name} vs #{fixture.away_team.name}"}
                    phx-value-selection="away_win"
                    phx-value-winner={fixture.away_team.id}
                  >
                    <%= Decimal.to_string(fixture.odds_away_win, :normal) |> String.slice(0..4) %>
                  </button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do

    current_user = socket.assigns[:current_user]

    IO.inspect(current_user, label: "Current User HOMELIVE")


    fixtures = Enum.map(Fixtures.list_fixtures2(), fn fixture ->
      Map.put(fixture, :odds_home_win, Decimal.to_string(fixture.odds_home_win, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_draw, Decimal.to_string(fixture.odds_draw, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_way_win, Decimal.to_string(fixture.odds_away_win, :normal) |> String.slice(0..4))
    end)

    total_odds = 0

    # Initialize results as an empty list
    {:ok, assign(socket, current_user: nil, fixtures: fixtures, results: [], total_odds: total_odds)}
  end

  def handle_event("add_to_results", %{"odds" => odds, "fixture" => fixture, "selection" => selection, "winner" => winner}, socket) do
    # Get the current list of results
    results = socket.assigns[:results] || []

    # Check if this fixture already has a selection
    updated_results =
      case Enum.find(results, fn result -> result.fixture == fixture end) do
        nil ->
          # If no existing selection, add a new result
          [%{fixture: fixture, odds: odds, selection: selection, winner: winner} | results]

        existing_result ->
          # If the fixture already has a result, update it with the new selection
          Enum.map(results, fn
            %{fixture: ^fixture} = result -> %{result | odds: odds, selection: selection, winner: winner}
            result -> result
          end)
      end

    # Calculate total odds as the product of selected odds
    total_odds = Enum.reduce(updated_results, Decimal.new(0), fn result, acc ->
      Decimal.add(acc, result.odds)
    end)

    # Update the socket assigns with the new list of results
    {:noreply, assign(socket, results: updated_results, total_odds: total_odds)}
  end

  def handle_event("place_bet", _params, socket) do
      # Extract required data
      results = socket.assigns[:results]

      # Retrieve current user from socket assigns
      current_user = socket.assigns[:current_user]

      # Debugging: Inspect current user
      IO.inspect(current_user, label: "Current User")

      # user_id = 1
      # # Extract results from the socket
      # results = socket.assigns[:results]

      # Format the data for insertion into the database
      bets = Enum.map(results, fn result ->
        %{
          fixture: result.fixture,
          odds: Decimal.new(result.odds), # Convert odds back to Decimal
          selection: result.selection,
          winner: result.winner,
          user_id: socket.assigns[:user_id], # Ensure user_id is assigned properly
          result: "", # Default value for result
        }
      end)

      # Bets.save_bets(socket, bets)


      IO.inspect(%{
        bets: bets
      }, label: "Placed Bet Data-")


      # Log the data or send it to the backend
      #  IO.inspect(%{
      #    results: results
      #  }, label: "Placed Bet Data")
    # Optionally, show a confirmation message or redirect
    {:noreply, socket}
  end
end
