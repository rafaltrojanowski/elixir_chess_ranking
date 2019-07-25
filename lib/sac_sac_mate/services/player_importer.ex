defmodule SacSacMate.Services.PlayerImporter do

  @moduledoc """
    Provides methods for scraping players data from Fide
  """

  @stardart_rank "https://ratings.fide.com/top.phtml?list=men"
  @rapid_rank "https://ratings.fide.com/top.phtml?list=men_rapid"
  @blits_rank "https://ratings.fide.com/top.phtml?list=men_blitz"

  def call do
    case HTTPoison.get(@stardart_rank,[], [ssl: [{:verify, :verify_none}]]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        table_rows = body
        |> Floki.parse()
        |> Floki.find("table.contentpaneopen:nth-of-type(2) tr:nth-of-type(2) table tr")
        |> Enum.with_index(1)
        |> Enum.map(&map_data/1)

        require IEx; IEx.pry
    end
  end

  defp map_data({{"tr", _attr, content}, index}) do
    case index do
     1 ->
      index # do nothing for table header row :)
     _ ->
      name = content |> get_name()
      country = content |> get_country()
      date_of_birth = content |> get_date_of_birth()

      %{
        name: name,
        country: country,
        date_of_birth: date_of_birth
      }

      # TODO: Insert data to Repo
    end
  end

  @doc """
    Returns a name in following format: Xiong, Jeffery""
  """
  defp get_name(content) do
    content
      |> Floki.find("td > a")
      |> Floki.text
  end

  @doc """
    Returns a country in following format: " NOR"
  """
  defp get_country(content) do
    Enum.at(content, 3) |> elem(2) |> to_string
  end

  @doc """
    Returns a country in following format: " 1990"
  """
  defp get_date_of_birth(content) do
    Enum.at(content, 6) |> elem(2) |> to_string
  end
end
