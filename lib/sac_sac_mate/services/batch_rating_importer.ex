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
  alias SacSacMate.Player.Rating

  require Logger

  @batch_size 5000

  def call(path) do
    {category, date} = get_category_and_date(path)

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
        |> bulk_insert(category, date)

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp bulk_insert(xml_data, category, date) do
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
      Repo.insert_all(Rating, rows)
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

  # TODO: move it to FileUtils
  defp get_category_and_date(path) do
    filename = String.split(path, "/") |> Enum.at(-1)
    category = String.split(filename, "_") |> Enum.at(0)
    substring = String.split(filename, "_") |> Enum.at(1)

    month = substring |> String.slice(0..2) |> month_map
    year = substring
           |> String.slice(3..4)
           |> String.pad_leading(4, "20") # TODO: Add support for years before 2000
           |> Integer.parse |> elem(0)
    {:ok, date} = Date.new(year, month, 1)
    {category, date}
  end

  # TODO: move it to DateUtils
  defp month_map(key) do
    %{
      :jan => 01,
      :feb => 02,
      :mar => 03,
      :apr => 04,
      :may => 05,
      :jun => 06,
      :jul => 07,
      :aug => 08,
      :sep => 09,
      :oct => 10,
      :nov => 11,
      :dec => 12
    }[String.to_atom(key)]
  end
end
