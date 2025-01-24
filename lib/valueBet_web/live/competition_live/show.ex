defmodule ValueBetWeb.CompetitionLive.Show do
  use ValueBetWeb, :live_view

  alias ValueBet.Competitions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:competition, Competitions.get_competition!(id))}
  end

  defp page_title(:show), do: "Show Competition"
  defp page_title(:edit), do: "Edit Competition"
end
