defmodule ValueBetWeb.UsersLive do
  use ValueBetWeb, :live_view

  alias ValueBet.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-2xl">
      <%= if @live_action == :view_permissions do %>
        <h2 class="text-2xl font-semibold mb-4">User Permissions</h2>
        <p class="mb-4">
          Viewing permissions for <strong><%= "#{@user.first_name} #{@user.last_name}" %></strong>.
        </p>

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
                          <td class="px-4 py-2 border-b">
                            <a href={~p"/users/#{@user.id}/remove"} class="text-blue-600 hover:underline">remove</a>
                          </td>
                        </tr>
                      <% end %>

                      <!-- Add row with dropdown for adding permission -->
                      <tr>
                        <td class="px-4 py-2 border-b">
                            <a href={~p"/users/#{@user.id}/add"} class="text-blue-600 hover:underline">add permission</a>
                        </td>
                        <td class="px-4 py-2 border-b"></td>
                      </tr>
                    </tbody>
                  </table>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        <div class="mt-4">
          <a href={~p"/users/list"} class="text-blue-600 hover:underline">Back to Users</a>
        </div>
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
                  <a href={~p"/users/#{user.id}"} class="text-blue-600 hover:underline">View</a>
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
    {:ok, assign(socket, users: [], user: nil, available_permissions: nil)}
  end


  def handle_params(%{"id" => id}, _url, socket) do
    case socket.assigns.live_action do
      :view_permissions ->
        handle_view_permissions(id, socket)

      :add_permissions ->
        handle_add_permissions(id, socket)

      _ ->
        {:noreply, socket}
    end
  end

  defp handle_view_permissions(id, socket) do
    case Accounts.get_user_with_roles_and_permissions(id) do
      nil ->
        {:noreply, push_navigate(socket, to: ~p"/users/list")}

      user ->
        available_permissions = Accounts.list_permissions()
        {:noreply, assign(socket, user: user, available_permissions: available_permissions)}
    end
  end

  defp handle_add_permissions(id, socket) do
    case Accounts.get_user_with_roles_and_permissions(id) do
      nil ->
        {:noreply, push_navigate(socket, to: ~p"/users/list")}

      user ->
        available_permissions = Accounts.list_permissions()
        {:noreply, assign(socket, user: user, available_permissions: available_permissions)}
    end
  end


  def handle_params(_params, _url, socket) do
    users = Accounts.list_users_with_roles()
    {:noreply, assign(socket, users: users)}
  end
end
