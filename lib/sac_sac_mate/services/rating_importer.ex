defmodule SacSacMate.Services.RatingImporter do

  @moduledoc """
    Deprecated!
    As inserting data one-by-one is very slow please use
    BatchRatingImporter with PlayerCreator to achieve the same result - faster!

    Get historical ratings from XML file
    It stores data in two tables: players and ratings
  """

  import SweetXml

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Utils
  require Logger

  def call(path) do
    {category, date} = Utils.File.get_category_and_date(path)

    Logger.info """
    Reading from #{path}...
    """

    case File.read(path) do
      {:ok, body} ->
        body
        |> xpath(
          ~x"//player"l,
          fideid: ~x"./fideid/text()",
          name: ~x"./name/text()",
          country: ~x"./country/text()",
          sex: ~x"./sex/text()",
          birthyear: ~x"./birthday/text()",
          age: ~x"./age/text()",
          rating: ~x"./rating/text()",
          k_factor: ~x"./k/text()",
          games: ~x"./games/text()"
        )
        |> insert_rating(category, date)

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp insert_rating(xml_data, category, date) do
    # IO.inspect xml_data
    xml_data |> (Enum.map fn (player_attributes) ->
      rating_attributes = assign_rating_attributes(player_attributes, category, date)

      player_data = get_player_data(player_attributes)
      player = get_player(player_data.fideid)

      if player do
        add_or_update_rating_for_player(player, date, rating_attributes)
      else
        add_new_player_with_rating(player_data, rating_attributes)
      end
    end)
  end

  defp assign_rating_attributes(player_attributes, category, date) do
    rating_value = player_attributes.rating |> to_string() |> Integer.parse |> elem(0)

    case String.to_atom(category) do
      :standard ->
        %{
          standard_rating: rating_value,
          date: date
        }
      :rapid ->
        %{
          rapid_rating: rating_value,
          date: date
        }
      :blitz ->
        %{
          blitz_rating: rating_value,
          date: date
        }
    end
  end

  defp get_player(fideid) do
    Repo.get_by(Player, fideid: fideid)
  end

  defp get_player_data(player_attributes) do
    name = player_attributes.name |> to_string()
    {first_name, last_name} = get_first_and_last_name(name)

    %{
      first_name: first_name,
      last_name: last_name,
      country: player_attributes.country |> to_string(),
      birthyear: get_birthyear(player_attributes),
      fideid: player_attributes.fideid |> to_string(),
      sex: player_attributes.sex |> to_string(),
    }
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

  defp add_new_player_with_rating(player_data, rating_attributes) do
    player_changeset = Player.changeset(%Player{},
      %{
        fideid: player_data.fideid,
        first_name: player_data.first_name,
        last_name: player_data.last_name,
        birthyear: player_data.birthyear,
        country: player_data.country,
        sex: player_data.sex
      }
    )

    case Repo.insert(player_changeset) do
      {:ok, player} ->

        changeset = Rating.changeset(%Rating{},
          Map.put(rating_attributes, :player_id, player.id)
        )

        case Repo.insert(changeset) do
          {:ok, rating} ->
            {:ok, rating}
          {:error, changeset} ->

            Logger.info Utils.Error.changeset_error_to_string(changeset)
            {:error, changeset}
        end

        {:ok, player}
      {:error, changeset} ->
        Logger.info Utils.Error.changeset_error_to_string(changeset)
        {:error, changeset}
    end
  end

  defp add_or_update_rating_for_player(player, date, rating_attributes) do
    rating = get_rating(player.id, date)

    if rating do
      changeset = Rating.changeset(rating,
        Map.put(rating_attributes, :player_id, player.id)
      )

      case Repo.update(changeset) do
        {:ok, rating} ->
          {:ok, rating}
        {:error, changeset} ->
          Logger.info Utils.Error.changeset_error_to_string(changeset)
          {:error, changeset}
      end
    else
      changeset = Rating.changeset(%Rating{},
        Map.put(rating_attributes, :player_id, player.id)
      )

      case Repo.insert(changeset) do
        {:ok, rating} ->
          {:ok, rating}
        {:error, changeset} ->
          Logger.info Utils.Error.changeset_error_to_string(changeset)
          {:error, changeset}
      end
    end
  end

  defp get_rating(player_id, date) do
    Repo.get_by(Rating, player_id: player_id, date: date)
  end

  defp get_birthyear(player_attributes) do
    case is_nil(player_attributes.birthyear) do
      false ->
        player_attributes.birthyear |> to_string() |> Integer.parse |> elem(0)
      true ->
        nil
    end
  end
end
