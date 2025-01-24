defmodule ValueBetWeb.LeagueLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Lueague
  alias ValueBet.Lueague.League

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :leagues, Lueague.list_leagues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit League")
    |> assign(:league, Lueague.get_league!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New League")
    |> assign(:league, %League{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leagues")
    |> assign(:league, nil)
  end

  @impl true
  def handle_info({ValueBetWeb.LeagueLive.FormComponent, {:saved, league}}, socket) do
    {:noreply, stream_insert(socket, :leagues, league)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    league = Lueague.get_league!(id)
    {:ok, _} = Lueague.delete_league(league)

    {:noreply, stream_delete(socket, :leagues, league)}
  end
end
