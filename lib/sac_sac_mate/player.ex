defmodule SacSacMate.Player do
  @moduledoc """
  The Player context.
  """

  import Ecto.Query, warn: false
  alias SacSacMate.Repo
import Torch.Helpers, only: [sort: 1, paginate: 4]
import Filtrex.Type.Config

alias SacSacMate.Player.Rating

@pagination [page_size: 15]
@pagination_distance 5

@doc """
Paginate the list of ratings using filtrex
filters.

## Examples

    iex> list_ratings(%{})
    %{ratings: [%Rating{}], ...}
"""
@spec paginate_ratings(map) :: {:ok, map} | {:error, any}
def paginate_ratings(params \\ %{}) do
  params =
    params
    |> Map.put_new("sort_direction", "desc")
    |> Map.put_new("sort_field", "inserted_at")

  {:ok, sort_direction} = Map.fetch(params, "sort_direction")
  {:ok, sort_field} = Map.fetch(params, "sort_field")

  with {:ok, filter} <- Filtrex.parse_params(filter_config(:ratings), params["rating"] || %{}),
       %Scrivener.Page{} = page <- do_paginate_ratings(filter, params) do
    {:ok,
      %{
        ratings: page.entries,
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

defp do_paginate_ratings(filter, params) do
  Rating
  |> Filtrex.query(filter)
  |> order_by(^sort(params))
  |> paginate(Repo, params, @pagination)
end

@doc """
Returns the list of ratings.

## Examples

    iex> list_ratings()
    [%Rating{}, ...]

"""
def list_ratings do
  Repo.all(Rating)
end

@doc """
Gets a single rating.

Raises `Ecto.NoResultsError` if the Rating does not exist.

## Examples

    iex> get_rating!(123)
    %Rating{}

    iex> get_rating!(456)
    ** (Ecto.NoResultsError)

"""
def get_rating!(id), do: Repo.get!(Rating, id)

@doc """
Creates a rating.

## Examples

    iex> create_rating(%{field: value})
    {:ok, %Rating{}}

    iex> create_rating(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_rating(attrs \\ %{}) do
  %Rating{}
  |> Rating.changeset(attrs)
  |> Repo.insert()
end

@doc """
Updates a rating.

## Examples

    iex> update_rating(rating, %{field: new_value})
    {:ok, %Rating{}}

    iex> update_rating(rating, %{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def update_rating(%Rating{} = rating, attrs) do
  rating
  |> Rating.changeset(attrs)
  |> Repo.update()
end

@doc """
Deletes a Rating.

## Examples

    iex> delete_rating(rating)
    {:ok, %Rating{}}

    iex> delete_rating(rating)
    {:error, %Ecto.Changeset{}}

"""
def delete_rating(%Rating{} = rating) do
  Repo.delete(rating)
end

@doc """
Returns an `%Ecto.Changeset{}` for tracking rating changes.

## Examples

    iex> change_rating(rating)
    %Ecto.Changeset{source: %Rating{}}

"""
def change_rating(%Rating{} = rating) do
  Rating.changeset(rating, %{})
end

defp filter_config(:ratings) do
  defconfig do
    number :standard_rating
      number :rapid_ranking
      number :blitz_ranking
      date :date
      number :player_id
      
  end
end
end
