defmodule ValueBetWeb.BetLive.Show do
  use ValueBetWeb, :live_view

  alias ValueBet.Bets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bet, Bets.get_bet!(id))}
  end

  defp page_title(:show), do: "Show Bet"
  defp page_title(:edit), do: "Edit Bet"
end
