defmodule SacSacMate.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SacSacMate.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias SacSacMate.Accounts.Player

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of players using filtrex
filters.

## Examples

    iex> list_players(%{})
    %{players: [%Player{}], ...}
"""
@spec paginate_players(map) :: {:ok, map} | {:error, any}
def paginate_players(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:players), params["player"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_players(filter, params) do
    {:ok,
      %{
        players: page.entries,
        page_number: page.page_number,
        page_size: page.page_size,
        total_pages: page.total_pages,
        total_entries: page.total_entries,
        distance: @pagination_distance,
        sort_field: sort_field,
        sort_direction: sort_direction
      }
    }
  else
    {:error, error} -> {:error, error}
    error -> {:error, error}
  end
end

defp do_paginate_players(filter, params) do
  Player
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of players.

## Examples

    iex> list_players()
    [%Player{}, ...]

"""
def list_players do
  Repo.all(Player)
end

@doc """
Gets a single player.

Raises `Ecto.NoResultsError` if the Player does not exist.

## Examples

    iex> get_player!(123)
    %Player{}

    iex> get_player!(456)
    ** (Ecto.NoResultsError)

"""
def get_player!(id), do: Repo.get!(Player, id)

@doc """
Creates a player.

## Examples

    iex> create_player(%{field: value})
    {:ok, %Player{}}

    iex> create_player(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_player(attrs \\ %{}) do
  %Player{}
  |> Player.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a player.

## Examples

    iex> update_player(player, %{field: new_value})
    {:ok, %Player{}}

    iex> update_player(player, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_player(%Player{} = player, attrs) do
  player
  |> Player.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Player.

## Examples

    iex> delete_player(player)
    {:ok, %Player{}}

    iex> delete_player(player)
    {:error, %Ecto.Changeset{}}

"""
def delete_player(%Player{} = player) do
  Repo.delete(player)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking player changes.

## Examples

    iex> change_player(player)
    %Ecto.Changeset{source: %Player{}}

"""
def change_player(%Player{} = player) do
  Player.changeset(player, %{})
end

defp filter_config(:players) do
  defconfig do
    text :first_name
    text :last_name
    text :country
    text :birthyear
    text :fide_title
    text :fide_women_title
    number :id
  end
end
end
