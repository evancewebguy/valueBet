defmodule ValueBetWeb.HomeLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Fixtures
  alias ValueBet.Bets

  def render(assigns) do
    ~H"""

      <div class="m-8 flex space-x-4">
        <!-- Left Column -->
        <div class="w-2/3 bg-gray-100 p-4 rounded-lg">
          <!-- Left content goes here - contain bets -->
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

        <!-- Right Column -->
        <div class="w-1/3 bg-gray-100 p-4 rounded-lg">
          <!-- Right content goes here -->
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
        </div>
      </div>




    """
  end

  def mount(_params, session, socket) do

    current_user = Map.get(session, "current_user", nil)

    fixtures = Enum.map(Fixtures.list_fixtures2(), fn fixture ->
      Map.put(fixture, :odds_home_win, Decimal.to_string(fixture.odds_home_win, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_draw, Decimal.to_string(fixture.odds_draw, :normal) |> String.slice(0..4))
      Map.put(fixture, :odds_way_win, Decimal.to_string(fixture.odds_away_win, :normal) |> String.slice(0..4))
    end)

    total_odds = 0

    # Initialize results as an empty list
    {:ok, assign(socket, current_user: current_user, fixtures: fixtures, results: [], total_odds: total_odds)}
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
      IO.inspect(current_user.id, label: "Current User placebet")

      # # Extract results from the socket
      # :bet_amount - amount placed
      # :odds - this game odds
      # :selection_choice - selected choice description e.g draw
      # :selected_winner - id of team selected to win
      # :actual_winner - the real winner id
      # :bet_status - "pending" # e.g., "won", "lost","canceled", "pending"
      # :bet_code - betslip code
      # :user - user id

      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)  # Truncate microseconds
      bet_code = generate_random_string()
       # Format the data for insertion into the database
      bets = Enum.map(results, fn result ->
        %{
          fixture: result.fixture,
          bet_amount: 100,
          odds: Decimal.new(result.odds),
          selection_choice: result.selection,
          selected_winner: result.winner,
          actual_winner: "",
          bet_status: "pending",
          bet_code: bet_code,
          user_id: current_user.id,
          inserted_at: now,  # Set inserted_at manually
          updated_at: now   # Set updated_at manually
        }
      end)

      # Log the bets data for debugging
      IO.inspect(bets, label: "Placed Bet Data")

      # Save the bets, handle success and failure
      case Bets.create_bets(bets) do
        {:ok, _} ->
          IO.puts("Bets successfully placed.")
                # Add a flash message and push a patch to the current route (or new one)
          socket =
            socket
            |> put_flash(:info, "Bet #{bet_code} placed successfully")
            |> push_patch(to: socket.assigns.patch)
        {:error, reason} ->
          IO.puts("Failed to place bets: #{reason}")
          # Optionally, add an error flash message
          socket =
            socket
            |> put_flash(:error, "Failed to place bet: #{inspect(reason)}")
            |> push_patch(to: socket.assigns.patch)
      end

      # Return :noreply as no state change is necessary for the socket
      {:noreply, socket}
  end

  def generate_random_string do
    prefix = "VALUEBET#"
    random_bytes = :crypto.strong_rand_bytes(8) # 8 bytes for a random string
    random_string = Base.encode16(random_bytes) |> String.slice(0..7) # Only take first 8 characters
    "#{prefix}#{random_string}"
  end
end
