defmodule ValueBetWeb.UserGamesLive do
  use ValueBetWeb, :live_view

  alias ValueBet.Accounts
  alias ValueBet.Bets


  # Render function for the live view
  def render(assigns) do
    ~H"""

      <div class="m-8 flex flex-col  space-x-4">
        <div>
          <a href={~p"/users/list"} class="text-blue-600 hover:underline">Back to users</a>

          <h2 class="text-2xl font-semibold mb-4">Games for <%= @selected_user.first_name %> <%= @selected_user.last_name %></h2>
        </div>


        <%= if length(@bet_history) > 1 do %>
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
        <% else %>
            <p>User has not placed any bet yet.</p>
        <% end %>
    </div>
    """
  end

  def mount(%{"id" => user_id}, _session, socket) do
    # Retrieve current user from socket assigns
    selected_user = Accounts.get_user(user_id)

    user_id = selected_user.id
    bet_history = Bets.list_bets_for_user(user_id)
    # IO.inspect(bet_history, label: "ALL BETS History forA USER")
    # Return the updated socket with the current_user assigned
    {:ok, assign(socket, selected_user: selected_user, bet_history: bet_history, filters: %{})}
  end

end
