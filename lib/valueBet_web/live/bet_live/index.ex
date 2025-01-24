defmodule ValueBetWeb.BetLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Bets
  alias ValueBet.Bets.Bet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :bets, Bets.list_bets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bet")
    |> assign(:bet, Bets.get_bet!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bet")
    |> assign(:bet, %Bet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bets")
    |> assign(:bet, nil)
  end

  @impl true
  def handle_info({ValueBetWeb.BetLive.FormComponent, {:saved, bet}}, socket) do
    {:noreply, stream_insert(socket, :bets, bet)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bet = Bets.get_bet!(id)
    {:ok, _} = Bets.delete_bet(bet)

    {:noreply, stream_delete(socket, :bets, bet)}
  end
end
