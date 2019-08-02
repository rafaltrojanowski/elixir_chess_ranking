defmodule SacSacMate.Services.BatchRatingImporter do

  @moduledoc """
    Get historical ratings from XML file
    It stores data in ratings table.
    Uses insert_all - a single database query for the entire operation
  """

  import SweetXml

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating

  require Logger

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
          # fideid: ~x"./fideid/text()",
          # name: ~x"./name/text()",
          # country: ~x"./country/text()",
          # sex: ~x"./sex/text()",
          # birthyear: ~x"./birthday/text()",
          # age: ~x"./age/text()",
          "#{category}_rating": ~x"./rating/text()"s |> transform_by(&String.to_integer/1),
          # k_factor: ~x"./k/text()",
          # games: ~x"./games/text()"
        )
        |> insert_rating(category, date)

      {:error, reason} ->
        IO.inspect reason
    end
  end

  defp insert_rating(xml_data, category, date) do
    datetime = NaiveDateTime.utc_now
    |> NaiveDateTime.truncate(:second)

    # See: https://github.com/elixir-ecto/ecto/issues/1932#issuecomment-314083252
    xml_data =
      xml_data
        |> Enum.map(fn(row) ->
            row
              |> Map.put(:inserted_at, datetime)
              |> Map.put(:updated_at, datetime)
          end)

    #TODO:
    # postgresql protocol can not handle 520770 parameters, the maximum is 65535
    # https://github.com/elixir-ecto/postgrex/issues/189
    Repo.insert_all(Rating, xml_data)
  end

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
