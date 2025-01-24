defmodule ValueBetWeb.CompetitionLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Competitions
  alias ValueBet.Competitions.Competition

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :competitions, Competitions.list_competitions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Competition")
    |> assign(:competition, Competitions.get_competition!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Competition")
    |> assign(:competition, %Competition{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Competitions")
    |> assign(:competition, nil)
  end

  @impl true
  def handle_info({ValueBetWeb.CompetitionLive.FormComponent, {:saved, competition}}, socket) do
    {:noreply, stream_insert(socket, :competitions, competition)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    competition = Competitions.get_competition!(id)
    {:ok, _} = Competitions.delete_competition(competition)

    {:noreply, stream_delete(socket, :competitions, competition)}
  end
end
