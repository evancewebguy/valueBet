defmodule ValueBet.Fixtures do
  @moduledoc """
  The Fixtures context.
  """

  import Ecto.Query, warn: false
  alias ValueBet.Repo

  alias ValueBet.Fixtures.Fixture
  alias ValueBet.Teams.Team


  # alias ValueBet.Team


  @doc """
  Returns the list of fixtures.

  ## Examples

      iex> list_fixtures()
      [%Fixture{}, ...]

  """
  # def list_fixtures do
  #   Repo.all(Fixture)
  # end

  def list_fixtures do
    Repo.all(
      Fixture
      |> join(:left, [f], t in Team, on: f.home_team_id == t.id, as: :home_team)
      |> join(:left, [f], t in Team, on: f.away_team_id == t.id, as: :away_team)
      |> preload([:home_team, :away_team])
    )
  end

  def list_fixtures2 do
    Repo.all(
      Fixture
      |> join(:left, [f], t in Team, on: f.home_team_id == t.id, as: :home_team)
      |> join(:left, [f], t in Team, on: f.away_team_id == t.id, as: :away_team)
      |> preload([:home_team, :away_team, :league, :competition])
    )
  end


  # def list_fixtures2 do
  #   Fixture
  #   |> join(:inner, [f], home_team in Team, on: f.home_team_id == home_team.id)
  #   |> join(:inner, [f], away_team in Team, on: f.away_team_id == away_team.id)
  #   |> select([f, home_team, away_team], %{
  #       id: f.id,
  #       fixture_date: f.fixture_date,
  #       home_team_id: f.home_team_id,
  #       home_team_name: home_team.name,
  #       away_team_id: f.away_team_id,
  #       away_team_name: away_team.name,
  #       odds_home_win: f.odds_home_win,
  #       odds_away_win: f.odds_away_win,
  #       odds_draw: f.odds_draw,
  #       status: f.status
  #   })
  #   |> Repo.all()
  # end





  @doc """
  Gets a single fixture.

  Raises `Ecto.NoResultsError` if the Fixture does not exist.

  ## Examples

      iex> get_fixture!(123)
      %Fixture{}

      iex> get_fixture!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixture!(id), do: Repo.get!(Fixture, id)

  @doc """
  Creates a fixture.

  ## Examples

      iex> create_fixture(%{field: value})
      {:ok, %Fixture{}}

      iex> create_fixture(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fixture(attrs \\ %{}) do
    %Fixture{}
    |> Fixture.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fixture.

  ## Examples

      iex> update_fixture(fixture, %{field: new_value})
      {:ok, %Fixture{}}

      iex> update_fixture(fixture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixture(%Fixture{} = fixture, attrs) do
    fixture
    |> Fixture.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fixture.

  ## Examples

      iex> delete_fixture(fixture)
      {:ok, %Fixture{}}

      iex> delete_fixture(fixture)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fixture(%Fixture{} = fixture) do
    Repo.delete(fixture)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fixture changes.

  ## Examples

      iex> change_fixture(fixture)
      %Ecto.Changeset{data: %Fixture{}}

  """
  def change_fixture(%Fixture{} = fixture, attrs \\ %{}) do
    Fixture.changeset(fixture, attrs)
  end
end
