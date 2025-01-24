defmodule ValueBetWeb.LeagueLive.FormComponent do
  use ValueBetWeb, :live_component

  alias ValueBet.Lueague

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage league records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="league-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save League</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{league: league} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Lueague.change_league(league))
     end)}
  end

  @impl true
  def handle_event("validate", %{"league" => league_params}, socket) do
    changeset = Lueague.change_league(socket.assigns.league, league_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"league" => league_params}, socket) do
    save_league(socket, socket.assigns.action, league_params)
  end

  defp save_league(socket, :edit, league_params) do
    case Lueague.update_league(socket.assigns.league, league_params) do
      {:ok, league} ->
        notify_parent({:saved, league})

        {:noreply,
         socket
         |> put_flash(:info, "League updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_league(socket, :new, league_params) do
    case Lueague.create_league(league_params) do
      {:ok, league} ->
        notify_parent({:saved, league})

        {:noreply,
         socket
         |> put_flash(:info, "League created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
