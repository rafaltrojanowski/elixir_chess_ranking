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
  @limit 100

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
          fideid: ~x"./fideid/text()"i,
          name: ~x"./name/text()"s,
          country: ~x"./country/text()"s,
          sex: ~x"./sex/text()"s,
          birthyear: ~x"./birthday/text()"s |> transform_by(&get_birthyear/1),
          "#{category}_rating": ~x"./rating/text()"i,
          "#{category}_games": ~x"./games/text()"i,
          "#{category}_k_factor": ~x"./k/text()"i
        )
        |> bulk_insert(date, category)

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp bulk_insert(xml_data, date, category) do
    datetime = NaiveDateTime.utc_now |> NaiveDateTime.truncate(:second)
    sort_key = String.to_atom("#{category}_rating")

    map = scope_to_insert(xml_data, sort_key)
      |> Enum.map(fn(row) ->
        row
        |> Map.put(:date, date)
        |> Map.put(:inserted_at, datetime)
        |> Map.put(:updated_at, datetime)
      end)

    # Postgresql protocol has a limit of maximum parameters (65535)
    list_of_chunks = Enum.chunk_every(map, @batch_size)

    Repo.transaction(fn ->
      Enum.each list_of_chunks, fn rows ->
        Repo.insert_all(Rating, rows, on_conflict: {:replace, replace_fields(category)},
          conflict_target: [:date, :fideid]
        )
      end
    end, timeout: :infinity)
  end

  defp scope_to_insert(map, sort_key, limit \\ @limit) do
    sorted = Enum.sort_by map, &Map.fetch(&1, sort_key), &>=/2
    elem = sorted |> Enum.at(limit - 1)
    Enum.filter(sorted, fn(row) -> row[sort_key] >= elem[sort_key] end)
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
