defmodule SacSacMate.Services.RatingImporter do

  @moduledoc """
    Get historical ratings from XML file
  """

  import SweetXml

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  alias SacSacMate.Accounts.Player
  require Logger

  def call(path) do
    case File.read(path) do
      {:ok, body} ->
        body
        |> xpath(
          ~x"//player"l,
          fideid: ~x"./fideid/text()",
          name: ~x"./name/text()",
          country: ~x"./country/text()",
          sex: ~x"./sex/text()",
          birthday: ~x"./birthday/text()",
          age: ~x"./age/text()",
          rating: ~x"./rating/text()",
          k_factor: ~x"./k/text()",
          games: ~x"./games/text()"
        )
        |> insert_rating()

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp insert_rating(data) do
    # IO.inspect data

    data |> (Enum.map fn (player_attributes) ->
      rating_attributes = %{
        standard_rating: player_attributes.rating |> to_string() |> Integer.parse |> elem(0),
        date: DateTime.utc_now() # TODO fix me
      }

      player_data = get_player_data(player_attributes)

      player = Repo.get_by(Player,
        first_name: player_data.first_name,
        last_name: player_data.last_name,
        country: player_data.country
      )

      if player do
        add_rating_for_player(player, rating_attributes)
      else
        add_new_player_with_rating(player_data, rating_attributes)
      end
    end)
  end

  defp get_player_data(player_attributes) do
    name = player_attributes.name

    %{
      first_name: name |> to_string() |> String.split(", ") |> Enum.at(1),
      last_name: name |> to_string() |> String.split(", ") |> Enum.at(0),
      country: player_attributes.country |> to_string(),
      birthday: player_attributes.birthday |> to_string(),
      fideid: player_attributes.fideid |> to_string(),
      sex: player_attributes.sex |> to_string(),
    }
  end

  defp add_rating_for_player(player, rating_attributes) do
    # TODO: consider update player here

    changeset = Rating.changeset(%Rating{},
      Map.put(rating_attributes, :player_id, player.id)
    )

    case Repo.insert(changeset) do
      {:ok, rating} ->
        {:ok, rating}
      {:error, changeset} ->
        Logger.info changeset_error_to_string(changeset)
        {:error, changeset}
    end
  end

  defp add_new_player_with_rating(player_data, rating_attributes) do

    player_changeset = Player.changeset(%Player{},
      %{
        first_name: player_data.first_name,
        last_name: player_data.last_name,
        country: player_data.country,
        birthday: player_data.birthday,
        sex: player_data.sex,
        fideid: player_data.fideid ,
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
            Logger.info changeset_error_to_string(changeset)
            {:error, changeset}
        end

        {:ok, player}
      {:error, changeset} ->
        Logger.info changeset_error_to_string(changeset)
        {:error, changeset}
    end
  end

  # TODO: Make it DRY.
  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end
end
