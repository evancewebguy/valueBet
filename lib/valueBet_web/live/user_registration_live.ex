defmodule ValueBetWeb.UserRegistrationLive do
  use ValueBetWeb, :live_view

  alias ValueBet.Accounts
  alias ValueBet.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:first_name]} type="text" label="First Name" required />
        <.input field={@form[:last_name]} type="text" label="Last Name" required />
        <.input field={@form[:phone]} type="text" label="Phone" required />


        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  # def handle_event("save", %{"user" => user_params}, socket) do
  #   case Accounts.register_user(user_params) do
  #     {:ok, user} ->
  #       # Assign the default role to the user
  #       case Accounts.assign_role_to_user(user.id, 1) do
  #         {:ok, _user_role} ->
  #           # Now assign multiple permissions to the user (e.g., Add Games, Add Admin to Access User)
  #           # 6 = "view sport games"
  #           # 7 = "Add Admin to Access User"
  #           # 8 = "cancel bets on the games"
  #           # 9 = " view accounts for winnings and losses"
  #           # 10 = "view history of your bets"
  #           permissions = [6, 7, 8, 9, 10]
  #           case Accounts.assign_permissions_to_user(user.id, permissions) do
  #             {:ok, _permissions} ->
  #               {:ok, _} =
  #                 Accounts.deliver_user_confirmation_instructions(
  #                   user,
  #                   &url(~p"/users/confirm/#{&1}")
  #                 )

  #               changeset = Accounts.change_user_registration(user)
  #               {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

  #             {:error, reason} ->
  #               {:noreply,
  #                socket
  #                |> put_flash(:error, "Could not assign permissions: #{reason}")
  #                |> assign_form(Accounts.change_user_registration(user))}
  #           end

  #         {:error, reason} ->
  #           {:noreply,
  #            socket
  #            |> put_flash(:error, "Could not assign default role: #{reason}")
  #            |> assign_form(Accounts.change_user_registration(user))}
  #       end

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
  #   end
  # end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # Assign the default role to the user (e.g., Role ID 1 for "User" or Role ID 2 for "Admin")
        default_role_id = 1 # Change this based on the role you want to assign by default
        case Accounts.assign_role_to_user(user.id, default_role_id) do
          {:ok, _user_role} ->
            # Define permissions based on the role
            permissions =
              case default_role_id do
                1 -> [6, 7, 8, 9, 10]         # Permissions for "User" role
              end

              # Assign the permissions to the role
              case Accounts.assign_permissions_to_role(1, permissions) do
                {:ok, _permissions} ->
                  {:ok, _} =
                    Accounts.deliver_user_confirmation_instructions(
                      user,
                      &url(~p"/users/confirm/#{&1}")
                    )

                  changeset = Accounts.change_user_registration(user)
                  {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

                {:error, reason} ->
                  {:noreply,
                  socket
                  |> put_flash(:error, "Could not assign permissions to the role: #{reason}")
                  |> assign_form(Accounts.change_user_registration(user))}
              end


          {:error, reason} ->
            {:noreply,
             socket
             |> put_flash(:error, "Could not assign default role: #{reason}")
             |> assign_form(Accounts.change_user_registration(user))}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  # def handle_event("save", %{"user" => user_params}, socket) do
  #   case Accounts.register_user(user_params) do
  #     {:ok, user} ->
  #       # Assign the default role to the user
  #       case Accounts.assign_role_to_user(user.id, 1) do
  #         {:ok, _user_role} ->
  #           {:ok, _} =
  #             Accounts.deliver_user_confirmation_instructions(
  #               user,
  #               &url(~p"/users/confirm/#{&1}")
  #             )

  #           changeset = Accounts.change_user_registration(user)
  #           {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

  #         {:error, reason} ->
  #           {:noreply,
  #             socket
  #             |> put_flash(:error, "Could not assign default role: #{reason}")
  #             |> assign_form(Accounts.change_user_registration(user))}
  #       end

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
  #   end
  # end



  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
