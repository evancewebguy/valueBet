# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ValueBet.Repo.insert!(%ValueBet.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias ValueBet.Accounts


roles_data = [
  %{
    name: "user",
    description: "Regular user with limited access."
  },
  %{
    name: "admin",
    description: "Administrator with full access to the system."
  }
]

Enum.each(roles_data, fn(data) ->
  Accounts.create_role!(data)
end)


permission_data = [
  %{
    name: "super admin",
    description: "configure games, grant admin access to a user, revoke admin access to a user."
  },
  %{
    name: "view a user",
    description: "view a user with all games they have placed."
  },
  %{
    name: "soft delete a user",
    description: "soft delete a user with all associated data."
  },
  %{
    name: "view profits",
    description: "view profits made from game losses."
  },
  %{
    name: "View sport games",
    description: "view all games available."
  },
  %{
    name: "Place bets on these games",
    description: "assume user has unlimited amount of money."
  },
  %{
    name: "Cancel bets on these bets",
    description: "Cancel bets on these bets."
  },
  %{
    name: "View accounts on winnings and losses",
    description: "View accounts on winnings and losses."
  },
  %{
    name: "View history of their bets",
    description: "View history of their bets."
  }
]

Enum.each(permission_data, fn(data) ->
  Accounts.create_permission!(data)
end)


role_permissions_data = [
  %{
    role_id: 1,
    permission_id: 5
  },
  %{
    role_id: 1,
    permission_id: 6
  },
  %{
    role_id: 1,
    permission_id: 7
  },
  %{
    role_id: 1,
    permission_id: 8
  },
  %{
    role_id: 1,
    permission_id: 9
  },
  %{
    role_id: 2,
    permission_id: 2
  },
  %{
    role_id: 2,
    permission_id: 3
  },
  %{
    role_id: 2,
    permission_id: 4
  },
  %{
    role_id: 2,
    permission_id: 5
  },
  %{
    role_id: 2,
    permission_id: 6
  },
  %{
    role_id: 2,
    permission_id: 7
  },
  %{
    role_id: 2,
    permission_id: 8
  },
  %{
    role_id: 2,
    permission_id: 9
  },
]

Enum.each(role_permissions_data, fn(data) ->
  Accounts.create_role_permission!(data)
end)
