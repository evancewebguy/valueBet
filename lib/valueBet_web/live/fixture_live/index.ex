defmodule ValueBetWeb.FixtureLive.Index do
  use ValueBetWeb, :live_view

  alias ValueBet.Fixtures
  alias ValueBet.Fixtures.Fixture

  @impl true
  def mount(_params, _session, socket) do
    fixtures = Fixtures.list_fixtures()

    # Example of accessing the teams
    for fixture <- fixtures do
      IO.inspect(fixture.home_team)  # Home team details
      IO.inspect(fixture.away_team)  # Away team details
    end

    {:ok, stream(socket, :fixtures, fixtures)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Fixture")
    |> assign(:fixture, Fixtures.get_fixture!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Fixture")
    |> assign(:fixture, %Fixture{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Fixtures")
    |> assign(:fixture, nil)
  end

  @impl true
  def handle_info({ValueBetWeb.FixtureLive.FormComponent, {:saved, fixture}}, socket) do
    {:noreply, stream_insert(socket, :fixtures, fixture)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    fixture = Fixtures.get_fixture!(id)
    {:ok, _} = Fixtures.delete_fixture(fixture)

    {:noreply, stream_delete(socket, :fixtures, fixture)}
  end
end
