defmodule ValueBetWeb.FixtureLive.ButtonComponent do
  use Phoenix.LiveComponent  # Use LiveComponent instead of :live_button_component

  @impl true
  def render(assigns) do
    ~H"""
    <button phx-click="handle_click" phx-value-id={@button_id} class="px-4 py-2 bg-blue-500 text-white rounded-md">
      <%= @label %>
    </button>
    """
  end

  # Mount callback (optional, here it's just a placeholder)
  def mount(socket) do
    {:ok, socket}
  end

  # Handle click event
  def handle_event("handle_click", %{"id" => button_id}, socket) do
    IO.puts("Button with ID #{button_id} clicked!")
    {:noreply, socket}
  end
end
