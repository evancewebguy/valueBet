defmodule ValueBet.Repo do
  use Ecto.Repo,
    otp_app: :valueBet,
    adapter: Ecto.Adapters.Postgres
end
