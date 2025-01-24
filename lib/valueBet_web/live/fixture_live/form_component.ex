defmodule ValueBetWeb.FixtureLive.FormComponent do
  use ValueBetWeb, :live_component

  alias ValueBet.Fixtures
  alias ValueBet.Teams


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage fixture records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="fixture-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <.input field={@form[:fixture_date]} type="datetime-local" label="Fixture date" />

        <!-- Home Team Selection -->
        <.input
          field={@form[:home_team_id]}
          type="select"
          label="Home Team"
          options={for team <- @teams, do: {team.name, team.id}}
        />

        <!-- Away Team Selection -->
        <.input
          field={@form[:away_team_id]}
          type="select"
          label="Away Team"
          options={for team <- @teams, do: {team.name, team.id}}
        />

        <.input field={@form[:odds_home_win]} type="number" label="Odds home win" step="any" />
        <.input field={@form[:odds_away_win]} type="number" label="Odds away win" step="any" />
        <.input field={@form[:odds_draw]} type="number" label="Odds draw" step="any" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={[
            {"Upcoming", "upcoming"},
            {"Ongoing", "ongoing"},
            {"Completed", "completed"}
          ]}
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Fixture</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{fixture: fixture} = assigns, socket) do
    # Fetch teams if not already assigned
    teams = assigns[:teams] || Teams.list_teams()

    {:ok,
    socket
    |> assign(assigns)
    |> assign(:teams, teams)  # Assign teams to the socket
    |> assign_new(:form, fn ->
      to_form(Fixtures.change_fixture(fixture))
    end)}
  end


  @impl true
  def handle_event("validate", %{"fixture" => fixture_params}, socket) do
    changeset = Fixtures.change_fixture(socket.assigns.fixture, fixture_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"fixture" => fixture_params}, socket) do
    save_fixture(socket, socket.assigns.action, fixture_params)
  end

  defp save_fixture(socket, :edit, fixture_params) do
    case Fixtures.update_fixture(socket.assigns.fixture, fixture_params) do
      {:ok, fixture} ->
        notify_parent({:saved, fixture})

        {:noreply,
         socket
         |> put_flash(:info, "Fixture updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_fixture(socket, :new, fixture_params) do
    # Ensure that home_team_id and away_team_id are part of the fixture_params
    home_team_id = Map.get(fixture_params, "home_team_id")
    away_team_id = Map.get(fixture_params, "away_team_id")

    # Add home_team_id and away_team_id to fixture_params if they are present
    updated_fixture_params =
      fixture_params
      |> Map.put("home_team_id", home_team_id)
      |> Map.put("away_team_id", away_team_id)
      |> Map.put("competition_id", 3)  # Set competition_id to 3 (e.g., EPL)
      |> Map.put("league_id", 1)       # Set league_id to 1 (e.g., EPL)

    # Pass updated_fixture_params to create_fixture
    case Fixtures.create_fixture(updated_fixture_params) do
      {:ok, fixture} ->
        notify_parent({:saved, fixture})

        {:noreply,
         socket
         |> put_flash(:info, "Fixture created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  # defp save_fixture(socket, :new, fixture_params) do

  #   # Ensure that home_team_id and away_team_id are part of the fixture_params
  #   home_team_id = Map.get(fixture_params, "home_team_id")
  #   away_team_id = Map.get(fixture_params, "away_team_id")

  #   # Add home_team_id and away_team_id to fixture_params if they are present
  #   updated_fixture_params =
  #     fixture_params
  #     |> Map.put("home_team_id", home_team_id)
  #     |> Map.put("away_team_id", away_team_id)
  #     |> Map.put("competition_id", 3)  # Set competition_id to 3 - epl
  #     |> Map.put("league_id", 1)       # Set league_id to 1 - epl


  #   case Fixtures.create_fixture(fixture_params) do
  #     {:ok, fixture} ->
  #       notify_parent({:saved, fixture})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Fixture created successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, form: to_form(changeset))}
  #   end
  # end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
