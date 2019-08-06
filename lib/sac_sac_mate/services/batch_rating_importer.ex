defmodule SacSacMate.Services.BatchRatingImporter do

  @moduledoc """
    Get historical ratings from XML file.
    It stores data in ratings table.
    Uses Repo.insert_all - a single database query for the entire operation.

    Sample XML entry:

    <player>
      <fideid>10207538</fideid>
      <name>A E M, Doshtagir</name>
      <country>BAN</country>
      <sex>M</sex>
      <title></title>
      <w_title></w_title>
      <o_title></o_title>
      <rating>1864</rating>
      <games>0</games>
      <k>30</k>
      <birthday></birthday>
      <flag>i</flag>
    </player>
  """

  import SweetXml

  alias SacSacMate.Repo
  alias SacSacMate.Utils
  alias SacSacMate.Player.Rating

  require Logger

  @batch_size 5000

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
          fideid: ~x"./fideid/text()"s |> transform_by(&String.to_integer/1),
          name: ~x"./name/text()"s |> transform_by(&to_string/1),
          country: ~x"./country/text()"s |> transform_by(&to_string/1),
          sex: ~x"./sex/text()"s |> transform_by(&to_string/1),
          birthyear: ~x"./birthday/text()"s |> transform_by(&get_birthyear/1) ,
          "#{category}_rating": ~x"./rating/text()"s |> transform_by(&String.to_integer/1),
          "#{category}_games": ~x"./games/text()"s |> transform_by(&String.to_integer/1),
          "#{category}_k_factor": ~x"./k/text()"s |> transform_by(&String.to_integer/1)
        )
        |> bulk_insert(date, category)

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp bulk_insert(xml_data, date, category) do
    datetime = NaiveDateTime.utc_now
    |> NaiveDateTime.truncate(:second)

    # See: https://github.com/elixir-ecto/ecto/issues/1932#issuecomment-314083252
    xml_data =
      xml_data
        |> Enum.map(fn(row) ->
            row
              |> Map.put(:date, date)
              |> Map.put(:inserted_at, datetime)
              |> Map.put(:updated_at, datetime)
          end)

    # Postgresql protocol has a limit of maximum parameters (65535)
    list_of_chunks = Enum.chunk_every(xml_data, @batch_size)
    Enum.each list_of_chunks, fn rows ->
      Repo.insert_all(Rating, rows, on_conflict: {:replace, replace_fields(category)},
        conflict_target: [:date, :fideid]
      )
    end
  end

  defp replace_fields(category) do
    case category do
      "standard" -> [:standard_rating, :standard_games, :standard_k_factor]
      "rapid" -> [:rapid_rating, :rapid_games, :rapid_k_factor]
      "blitz" -> [ :blitz_rating, :blitz_games, :blitz_k_factor ]
    end
  end

  defp get_birthyear(string) do
    case string == "" do
      true ->
        nil
      false ->
        string |> String.to_integer
    end
  end
end
