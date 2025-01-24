defmodule ValueBetWeb.LeagueLive.Show do
  use ValueBetWeb, :live_view

  alias ValueBet.Lueague

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:league, Lueague.get_league!(id))}
  end

  defp page_title(:show), do: "Show League"
  defp page_title(:edit), do: "Edit League"
end
