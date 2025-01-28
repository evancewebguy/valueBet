defmodule ValueBet.Bets.Bet do
  use Ecto.Schema
  import Ecto.Changeset


    schema "bets" do
      field :fixture, :string
      field :bet_amount, :integer
      field :odds, :decimal
      field :selection_choice, :string
      field :selected_winner, :string
      field :actual_winner, :string
      field :bet_status, Ecto.Enum, values: [:upcoming, :cancelled, :won, :lost], default: :upcoming
      field :bet_code, :string
      field :user_id, :integer
      field :deleted_at, :utc_datetime



      # belongs_to :user, ValueBet.User

      timestamps()
    end

    @doc false
    def changeset(bet, attrs) do
      bet
      |> cast(attrs, [:fixture, :bet_amount, :odds, :selection_choice, :selected_winner, :actual_winner, :bet_status, :bet_code, :user_id])
      |> validate_required([:fixture, :bet_amount, :odds, :selection_choice, :selected_winner, :bet_code, :user_id])
      |> validate_number(:bet_amount, greater_than: 0)
      |> validate_number(:odds, greater_than: 1.0)
    end
end
