defmodule ValueBetWeb.BetHistoryLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Bets

  def render(assigns) do
    ~H"""
      <div class="m-8 flex flex-col  space-x-4">
        <div>
          <h2 class="text-2xl font-semibold mb-4">Bet History</h2>
        </div>
        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left border-b">
                Bet Code
                <input
                  type="text"
                  placeholder="Filter Bet Code"
                  class="w-full mt-1 border rounded px-2 py-1 text-sm"
                  phx-change="filter"
                  phx-debounce="500"
                  phx-target="@myself"
                  phx-value-field="bet_code"
                />
              </th>
              <th class="px-4 py-2 text-left border-b">
                Fixture
                <input
                  type="text"
                  placeholder="Filter Fixture"
                  class="w-full mt-1 border rounded px-2 py-1 text-sm"
                  phx-change="filter"
                  phx-debounce="500"
                  phx-value-field="fixture"
                  phx-value={@filters["fixture"] || ""}
                />

              </th>
              <th class="px-4 py-2 text-left border-b">
                Bet Status
                <select
                  class="w-full mt-1 border rounded px-2 py-1 text-sm"
                  phx-change="filter"
                  phx-debounce="500"
                  phx-value-field="bet_status"
                  phx-value={@filters["bet_status"] || ""}
                >
                  <option value="">All</option>
                  <option value="pending">Pending</option>
                  <option value="cancelled">Cancelled</option>
                  <option value="won">Won</option>
                  <option value="lost">Lost</option>
                </select>

              </th>
              <th class="px-4 py-2 text-left border-b">
                Bet Time
              </th>
              <th class="px-4 py-2 text-left border-b">Action</th>
            </tr>
          </thead>
          <tbody>
            <%= for bet <- @bet_history do %>
              <tr>
                <td class="px-4 py-2 border-b"><%= "#{bet.bet_code}" %></td>
                <td class="px-4 py-2 border-b"><%= bet.fixture %></td>
                <td class="px-4 py-2 border-b"><%= bet.bet_status %></td>
                <td class="px-4 py-2 border-b">
                  <%= bet.inserted_at
                      |> NaiveDateTime.to_date()
                      |> Date.to_string()
                      |> String.slice(0..15) %>
                </td>
                <td class="px-4 py-2 border-b">
                  <%= if bet.bet_status == "pending" do %>
                    <button class="cancel-button" phx-click="cancel_bet" phx-value-bet-id={bet.id}>Cancel</button>
                  <% else %>
                    <span>Bet ongoing/ended</span>
                  <% end %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>

      </div>
    """
  end

  def mount(_params, _session, socket) do
      # Retrieve current user from socket assigns
      current_user = socket.assigns[:current_user]

      # Debugging: Inspect current user
      # IO.inspect(current_user.id, label: "Current User ID History")

      user_id = current_user.id
      bet_history = Bets.list_bets_for_user(user_id)

      # IO.inspect(bet_history, label: "ALL BETS History")

      {:ok, assign(socket, current_user: current_user, bet_history: bet_history,filters: %{})}
  end



  def handle_event("cancel_bet", %{"bet-id" => bet_id}, socket) do
    # Fetch the bet by its ID
    bet_to_cancel = Bets.get_bet!(bet_id)

    IO.inspect(bet_to_cancel, label: "BET TO CANCEL")

    # Proceed with cancelling the bet
    case Bets.update_bet_status(bet_to_cancel, "cancelled") do
      {:ok, _} ->
        IO.puts("Bet cancelled successfully.")

        # Add a flash message and push a patch to the current route (or a new one)
        socket =
          socket
          |> put_flash(:info, "Bet cancelled successfully")  # Success message
          |> push_patch(to: socket.assigns.patch)

      {:error, reason} ->
        IO.puts("Failed to cancel bet: #{reason}")
        # Optionally, add an error flash message
        socket =
          socket
          |> put_flash(:error, "Failed to cancel bet: #{inspect(reason)}")  # Error message
          |> push_patch(to: socket.assigns.patch || socket.assigns.live_action)  # Use the current route or fallback to live_action
    end

    {:noreply, socket}
  end

  def handle_event("filter", params, socket) do

    IO.inspect(params, label: "Filter Params")

    field = Map.get(params, "phx-value-field", "")
    value = Map.get(params, "value", "")

    IO.inspect(field, label: "Current field")

    # Update the filters
    filters = Map.put(socket.assigns.filters || %{}, field, value)

    IO.inspect(filters, label: "BET FILTERS")

    # Fetch the filtered data
    bet_history = Bets.list_bets_with_filters(filters)

    {:noreply, assign(socket, bet_history: bet_history, filters: filters)}
  end

end
