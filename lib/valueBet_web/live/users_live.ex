defmodule ValueBetWeb.UsersLive do
  use ValueBetWeb, :live_view

  alias ValueBet.Accounts

  def render(assigns) do
    ~H"""
    <div class="m-8 flex flex-col  space-x-4">

      <div class="mt-4">
        <a href={~p"/users/list"} class="text-blue-600 hover:underline">Back to Users</a>
      </div>

      <%= if @live_action in [:view_permissions, :add_permissions] do %>
        <h2 class="text-2xl font-semibold mb-4">
          <%= if @live_action == :view_permissions, do: "User Permissions", else: "Add Permission" %> : <%= @user.first_name %> <%= @user.last_name %>
        </h2>

        <div>
          <!-- Success Message -->
          <%= if @success_message do %>
            <div class="alert alert-success">
              <%= @success_message %>
            </div>
          <% end %>

          <!-- Error Message -->
          <%= if @error_message do %>
            <div class="alert alert-danger">
              <%= @error_message %>
            </div>
          <% end %>
        </div>


          <%= if Enum.any?(@current_user.user_roles, fn role -> role.role_id == 1 end) and
                Enum.any?(@current_user.user_roles, fn role -> role.role_id == 2 end) do %>

              <!-- User has both roles 1 and 2. (admin) -->
              <!-- Revoke super user rights (admin) -->
              <!-- User has both roles 1 and 2. (admin) -->

                <%= if Enum.count(@user.user_roles) == 1 and Enum.any?(@user.user_roles, fn role -> role.role.name == "user" end) do %>
                  <div class="mt-4">
                    <button
                      class="mb-1 bg-gray-400 text-white px-4 py-1 rounded hover:bg-gray-500"
                      phx-click="make_admin"
                      phx-value-user-id={@user.id}
                    >
                      Make <%= @user.first_name %> Admin
                    </button>
                  </div>
                <% end %>


                <%= if Enum.count(@user.user_roles) == 2 and Enum.any?(@user.user_roles, fn role -> role.role.name == "admin" end) do %>
                  <div class="mt-4">
                    <button
                      class="mb-1 bg-gray-400 text-white px-4 py-1 rounded hover:bg-gray-500"
                      phx-click="revoke_admin"
                      phx-value-user-id={@user.id}
                    >
                      Revoke <%= @user.first_name %> Admin Rights
                    </button>

                    <button
                      class="mb-1 bg-gray-500 text-white px-4 py-1 rounded hover:bg-gray-600"
                      phx-click="make_super_admin"
                      phx-value-user-id={@user.id}
                    >
                      Make <%= @user.first_name %> Super Admin
                    </button>

                    <button
                      class="mb-1 bg-red-400 text-white px-4 py-1 rounded hover:bg-red-500"
                      phx-click="remove_super_admin"
                      phx-value-user-id={@user.id}
                    >
                      Remove <%= @user.first_name %> from Super Admin
                    </button>
                  </div>
                <% end %>


              <%= if Enum.any?(@current_user.user_permissions, fn permission -> permission.permission_id == 1 end) do %>
                <!-- <p>Admin User Is a Super Admin</p> -->
                <!-- make user a super admin, -->
                <!-- revoke admin access -->
            <% else %>
                  Show Admin related content
            <% end %>
          <% end %>


        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left border-b">Role</th>
              <th class="px-4 py-2 text-left border-b">Permissions</th>
            </tr>
          </thead>
          <tbody>
            <%= for role <- @user.user_roles do %>
              <tr>
                <td class="px-4 py-2 border-b"><%= role.role.name %></td>
                <td class="px-4 py-2 border-b">
                  <table class="min-w-full">
                    <tbody>
                      <%= for permission <- role.role.permissions do %>
                        <tr>
                          <td class="px-4 py-2 border-b"><%= permission.name %></td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>

      <% else %>
        <h2 class="text-2xl font-semibold mb-4">Users</h2>
        <table class="min-w-full bg-white border border-gray-200">
          <thead>
            <tr>
              <th class="px-4 py-2 text-left border-b">Full Name</th>
              <th class="px-4 py-2 text-left border-b">Email</th>
              <th class="px-4 py-2 text-left border-b">Role</th>
              <th class="px-4 py-2 text-left border-b">Action</th>
            </tr>
          </thead>
          <tbody>
            <%= for user <- @users do %>
              <tr>
                <td class="px-4 py-2 border-b"><%= "#{user.first_name} #{user.last_name}" %></td>
                <td class="px-4 py-2 border-b"><%= user.email %></td>
                <td class="px-4 py-2 border-b">
                  <%= for role <- user.user_roles do %>
                    <%= role.role.name %><%= if role != List.last(user.user_roles), do: ", " %>
                  <% end %>
                </td>
                <td class="px-4 py-2 border-b">
                  <a href={~p"/users/#{user.id}"} class="text-blue-600 hover:underline">View </a>|
                  <a href={~p"/users/#{user.id}/games"} class="text-blue-600 hover:underline">games</a>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
      <% end %>
    </div>
    """
  end


  def mount(_params, _session, socket) do
    available_permissions = Accounts.list_permissions()
    user_permissions = nil

    {:ok, assign(socket, users: [], user: nil, user_permissions: user_permissions, available_permissions: available_permissions, success_message: nil, error_message: nil)}
  end


  def handle_params(%{"id" => id}, _url, socket) do
    case socket.assigns.live_action do
      :view_permissions -> handle_permissions(id, socket)
      :add_permissions -> handle_permissions(id, socket)
      _ -> {:noreply, socket}
    end
  end

  defp handle_permissions(id, socket) do
    case Accounts.get_user_with_roles_and_permissions(id) do
      nil ->
        {:noreply, push_navigate(socket, to: ~p"/users/list")}

      user ->
         # Fetch available permissions
        available_permissions = Accounts.list_permissions()

        # Get the user permissions
        user_permissions = Accounts.get_user_with_permissions(id)

       IO.inspect(is_list(user_permissions), label: "user_permissions")


        {:noreply, assign(socket, user: user, available_permissions: available_permissions, user_permissions: user_permissions)}
    end
  end


  def handle_event("make_admin", %{"user-id" => user_id}, socket) do
    case Accounts.assign_role_to_user(user_id, 2) do
      :ok ->
        {:noreply, assign(socket, :success_message, "User successfully promoted to admin!")}

      {:error, reason} ->
        {:noreply, assign(socket, :error_message, "Failed to make user admin: #{reason}")}
    end
  end

  def handle_event("revoke_admin", %{"user-id" => user_id}, socket) do
    case Accounts.revoke_role_to_user(user_id, 2) do
      :ok ->
        {:noreply, assign(socket, :success_message, "User Role successfully Revoked!")}

      {:error, reason} ->
        {:noreply, assign(socket, :error_message, "Failed to revoke user admin: #{reason}")}
    end
  end



  def handle_event("make_super_admin", %{"user-id" => user_id}, socket) do
    #makes user a super admin
    case Accounts.assign_permission_to_user(user_id, 1) do
      :ok ->
        IO.inspect(%{
          user_id: user_id,
          permission_id: 1,
          status: "success"
        }, label: "User promoted to super admin")

        {:noreply, assign(socket, :success_message, "User successfully promoted to super admin!")}

      {:error, reason} ->
        IO.inspect(%{
          user_id: user_id,
          permission_id: 1,
          status: "error",
          reason: reason
        }, label: "Failed to promote user to super admin")

        {:noreply, assign(socket, :error_message, "Failed to make user super admin: #{reason}")}
    end
  end

  def handle_event("remove_super_admin", %{"user-id" => user_id}, socket) do
    case Accounts.remove_permission_from_user(user_id, 1) do
      :ok ->
        {:noreply, assign(socket, :success_message, "User successfully removed from super admin!")}

      {:error, reason} ->
        {:noreply, assign(socket, :error_message, "Failed to remove user from super admin: #{reason}")}
    end
  end


  def handle_params(_params, _url, socket) do
    users = Accounts.list_users_with_roles()
    {:noreply, assign(socket, users: users)}
  end
end
