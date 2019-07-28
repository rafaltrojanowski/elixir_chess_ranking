defmodule SacSacMate.Services.RatingImporter do

  @moduledoc """
    TODO
  """

  import SweetXml

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  require Logger

  def call(path) do
    case File.read(path) do
      {:ok, body} ->
        body
        |> xpath(
          ~x"//player"l,
          fideid: ~x"./fideid/text()",
          country: ~x"./country/text()",
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
      # %{
        # age: nil,
        # country: 'IND',
        # fideid: '35004336',
        # name: 'Aakash S B',
        # rating: '1221',
        # sex: 'M'
      # }

      changeset = Rating.changeset(%Rating{}, player_attributes)

      case Repo.insert(changeset) do
        {:ok, rating} ->
          {:ok, rating}
        {:error, changeset} ->
          # Logger.info changeset_error_to_string(changeset)
          {:error, changeset}
      end
    end
  end
end
