defmodule SacSacMate.Services.PlayerCreator do

  @moduledoc """
  Populates 'players' table based on 'ratings' table.
  Creates relationship between those two tables.
  """

  import Ecto.Query

  alias SacSacMate.Player.Rating
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Repo

  def call do
    query = from(r in Rating, order_by: [asc: r.date])
    data = Repo.all(query)


    # NOTE: This is not a best way to iterate over large collections
    Enum.each data, fn rating ->
      case Repo.get_by(Player, %{fideid: rating.fideid}) do
        nil  ->
          insert_player(rating)
        player ->
          update_player_and_rating(player, rating)
      end
    end
  end

  defp update_player_and_rating(player, rating) do
    player_changeset = Ecto.Changeset.change player,
      fide_title: rating.fide_title,
      fide_women_title: rating.fide_women_title
    case Repo.update player_changeset do
      {:ok, struct} -> struct
      {:error, changeset} -> changeset
    end

    rating_changeset = Rating.changeset(rating, %{player_id: player.id})
    case Repo.update rating_changeset do
      {:ok, struct} -> struct
      {:error, changeset} -> changeset
    end
  end

  defp insert_player(rating) do
    {first_name, last_name} = get_first_and_last_name(rating.name)

    player = Repo.insert!(%Player{
      fideid: rating.fideid,
      first_name: first_name,
      last_name: last_name,
      sex: rating.sex,
      country: rating.country,
      birthyear: rating.birthyear,
      fide_title: rating.fide_title,
      fide_women_title: rating.fide_women_title
    })

    changeset = Rating.changeset(rating,
      %{player_id: player.id}
    )

    Repo.update(changeset)
  end

  defp get_first_and_last_name(name) do
    separator = case name =~ ", " do
      true -> ", "
      false -> " "
    end
    first_name = name |> to_string() |> String.split(separator) |> Enum.at(1)
    last_name = name |> to_string() |> String.split(separator) |> Enum.at(0)

    {first_name, last_name}
  end
end
