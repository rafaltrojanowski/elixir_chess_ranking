defmodule SacSacMate.Utils.File do

  @moduledoc """
  Extracts rating category and date from filename
  Example filename: blitz_apr14frl_xml.xml
  """

  alias SacSacMate.Utils

  def get_category_and_date(path) do
    filename = String.split(path, "/") |> Enum.at(-1)
    category = String.split(filename, "_") |> Enum.at(0)
    substring = String.split(filename, "_") |> Enum.at(1)

    month = substring |> String.slice(0..2) |> Utils.Date.month_map
    year = substring
           |> String.slice(3..4)
           |> String.pad_leading(4, "20") # TODO: Add support for years before 2000
           |> Integer.parse |> elem(0)
    {:ok, date} = Date.new(year, month, 1)
    {category, date}
  end
end
