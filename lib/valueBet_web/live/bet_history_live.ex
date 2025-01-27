defmodule ValueBetWeb.BetHistoryLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Bets

  def render(assigns) do
    ~H"""
    <div class="m-8 flex flex-col space-x-4">
      <div>
        <h2 class="text-2xl font-semibold mb-4">Bet History</h2>
      </div>

      <!-- Filter Form -->
      <form phx-change="filter" phx-debounce="500" phx-target="@myself">
        <div class="flex space-x-4 mb-4">
          <!-- Bet Code Filter -->
          <div>
            <label for="bet_code" class="block text-sm font-medium">Bet Code</label>

            <input
              type="text"
              placeholder="Filter Bet Code"
              class="w-full mt-1 border rounded px-2 py-1 text-sm"
              phx-change="filter"
              phx-debounce="500"
              phx-value-field="bet_code"
              phx-value={@filters["bet_code"] || ""}
            />
          </div>

          <!-- Fixture Filter -->
          <div>
            <label for="fixture" class="block text-sm font-medium">Fixture</label>
            <input
              id="fixture"
              type="text"
              placeholder="Filter Fixture"
              class="w-full mt-1 border rounded px-2 py-1 text-sm"
              phx-change="filter"
              phx-value-field="fixture"
              phx-value={@filters["fixture"] || ""}
            />
          </div>

          <!-- Bet Status Filter -->
          <div>
            <label for="bet_status" class="block text-sm font-medium">Bet Status</label>
            <select
              id="bet_status"
              class="w-full mt-1 border rounded px-2 py-1 text-sm"
              phx-change="filter"
              phx-value-field="bet_status"
              phx-value={@filters["bet_status"] || ""}
            >
              <option value="">All</option>
              <option value="pending">Pending</option>
              <option value="cancelled">Cancelled</option>
              <option value="won">Won</option>
              <option value="lost">Lost</option>
            </select>
          </div>
        </div>
      </form>

      <!-- Bet History Table -->
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
              <td class="px-4 py-2 border-b"><%= bet.bet_code %></td>
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
    IO.inspect(params, label: "Received filter params")

    # Extract the filter field and value
    field = Map.get(params, "phx-value-field", "")
    value = Map.get(params, "phx-value", "")

    IO.inspect(field, label: "Field")
    IO.inspect(value, label: "Value")

    # Proceed only if both field and value are present
    if field != "" and value != "" do
      # Update filters map
      filters = Map.put(socket.assigns.filters || %{}, field, value)
      IO.inspect(filters, label: "Updated filters")

      # Fetch filtered data
      bet_history = Bets.list_bets_with_filters(filters)

      IO.inspect(bet_history, label: "FILTERED BET HISTORY")

      socket =
        socket
        |> assign(:filters, filters)
        |> assign(:bet_history, bet_history)
        |> put_flash(:info, "Bet filtered successfully")
        |> push_patch(to: socket.assigns.patch)

      {:noreply, socket}
    else
      IO.warn("No valid field or value provided for filtering")
      {:noreply, socket}
    end
  end


  # def handle_event("filter", params, socket) do
  #   IO.inspect(params, label: "Received filter params")

  #   # Safely extract field and value from params
  #   field = Map.get(params, "phx-value-field", "")
  #   value = Map.get(params, "phx-value", "")

  #   IO.inspect(field, label: "Field")
  #   IO.inspect(value, label: "Value")

  #   # Only proceed if both field and value are present
  #   if field != "" and value != "" do
  #     filters = Map.put(socket.assigns.filters || %{}, field, value)
  #     IO.inspect(filters, label: "Updated filters")

  #     bet_history = Bets.list_bets_with_filters(filters)

  #     IO.inspect(bet_history, label: "FILTERED BET HISTORY")

  #     socket =
  #       socket
  #       |> put_flash(:info, "Bet filtered successfully")  # Success message
  #       |> push_patch(to: socket.assigns.patch)

  #   else
  #     IO.warn("No valid field or value provided for filtering")
  #     {:noreply, socket}
  #   end
  # end


  # def handle_event("filter", params, socket) do
  #   IO.inspect(params, label: "Filter Params")

  #   # Retrieve the field and value from the params
  #   field = Map.get(params, "phx-value-field", "")
  #   value = Map.get(params, "phx-value", "")

  #   IO.inspect(field, label: "Current field")
  #   IO.inspect(value, label: "Current value")

  #   # Update the filters map
  #   filters = Map.put(socket.assigns.filters || %{}, field, value)

  #   IO.inspect(filters, label: "Updated BET FILTERS")

  #   # Fetch the filtered data using the filters
  #   bet_history = Bets.list_bets_with_filters(filters)

  #   {:noreply, assign(socket, bet_history: bet_history, filters: filters)}
  # end


  # def handle_event("filter", params, socket) do
  #   IO.inspect(params, label: "Filter Params")

  #   field = Map.get(params, "phx-value-field", "")
  #   value = Map.get(params, "value", "")

  #   IO.inspect(field, label: "Current field")

  #   # Update the filters
  #   filters = Map.put(socket.assigns.filters || %{}, field, value)

  #   IO.inspect(filters, label: "BET FILTERS")

  #   # Fetch the filtered data using the filters
  #   bet_history = Bets.list_bets_with_filters(filters)

  #   {:noreply, assign(socket, bet_history: bet_history, filters: filters)}
  # end


  # def handle_event("filter", %{"phx-value-field" => field, "value" => value}, socket) do
  #   IO.inspect({"Field", field}, label: "Filter Field")
  #   IO.inspect({"Value", value}, label: "Filter Value")

  #   # Ensure that the value is empty string if no value is provided
  #   value = if value == "", do: nil, else: value

  #   # Update the filters with the new value for the given field
  #   filters = Map.put(socket.assigns.filters || %{}, field, value)

  #   IO.inspect(filters, label: "Updated Filters")

  #   # Fetch the filtered data using the filters
  #   bet_history = Bets.list_bets_with_filters(filters)

  #   {:noreply, assign(socket, bet_history: bet_history, filters: filters)}
  # end


end
