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
          country: ~x"./country/text()",
          birthday: ~x"./birthday/text()",
          name: ~x"./name/text()",
          age: ~x"./age/text()",
          sex: ~x"./sex/text()",
          rating: ~x"./rating/text()"
        )
        |> insert_rating()

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp insert_rating(data) do
    IO.inspect data

    data
    |> Enum.map fn (player_attributes) ->

      rating_attributes = %{
        standard_rating: player_attributes.rating |> to_string() |> Integer.parse |> elem(0)
      }

      name = player_attributes.name
      first_name = name |> to_string() |> String.split(", ") |> Enum.at(1)
      last_name = name |> to_string() |> String.split(", ") |> Enum.at(0)

      player_changeset = Player.changeset(%Player{},
        %{
          first_name: first_name,
          last_name: last_name,
          country: player_attributes.country |> to_string(),
          birthday: player_attributes.birthday |> to_string()
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
