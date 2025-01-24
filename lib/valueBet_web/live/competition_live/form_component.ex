defmodule ValueBetWeb.CompetitionLive.FormComponent do
  use ValueBetWeb, :live_component

  alias ValueBet.Competitions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage competition records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="competition-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:code]} type="text" label="Code" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Competition</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{competition: competition} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Competitions.change_competition(competition))
     end)}
  end

  @impl true
  def handle_event("validate", %{"competition" => competition_params}, socket) do
    changeset = Competitions.change_competition(socket.assigns.competition, competition_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"competition" => competition_params}, socket) do
    save_competition(socket, socket.assigns.action, competition_params)
  end

  defp save_competition(socket, :edit, competition_params) do
    case Competitions.update_competition(socket.assigns.competition, competition_params) do
      {:ok, competition} ->
        notify_parent({:saved, competition})

        {:noreply,
         socket
         |> put_flash(:info, "Competition updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_competition(socket, :new, competition_params) do
    case Competitions.create_competition(competition_params) do
      {:ok, competition} ->
        notify_parent({:saved, competition})

        {:noreply,
         socket
         |> put_flash(:info, "Competition created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
