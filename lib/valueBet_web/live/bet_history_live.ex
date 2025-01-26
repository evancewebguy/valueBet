defmodule ValueBetWeb.BetHistoryLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Bets

  def render(assigns) do
    ~H"""
        <h2 class="text-2xl font-semibold mb-4">Bet History</h2>
        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left border-b">Bet Code</th>
              <th class="px-4 py-2 text-left border-b">Fixture</th>
              <th class="px-4 py-2 text-left border-b">Bet Status</th>
              <th class="px-4 py-2 text-left border-b">Bet Time</th>
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
                    <button class="cancel-button" phx-click="cancel_bet" phx-value-bet-id={bet.id }>Cancel</button>
                  <% else %>
                    <span>Bet ongoing/ended</span>
                  <% end %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
    """
  end

  def mount(_params, _session, socket) do
      # Retrieve current user from socket assigns
      current_user = socket.assigns[:current_user]

      # Debugging: Inspect current user
      IO.inspect(current_user.id, label: "Current User ID History")

      user_id = current_user.id
      bet_history = Bets.list_bets_for_user(user_id)

      # IO.inspect(bet_history, label: "ALL BETS History")

      {:ok, assign(socket, current_user: current_user, bet_history: bet_history)}
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


end
