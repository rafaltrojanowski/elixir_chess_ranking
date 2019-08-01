defmodule SacSacMate.Services.PlayerImporter do

  @moduledoc """
    Provides methods for scraping players data from Fide webpages

    NOTE: Deprecated! It does not provide mandatory fideid field
          Please use RatingImporter instead.
  """

  alias SacSacMate.Accounts.Player
  alias SacSacMate.Repo
  require Logger

  @stardard_rank "https://ratings.fide.com/top.phtml?list=men"
  @rapid_rank "https://ratings.fide.com/top.phtml?list=men_rapid"
  @blitz_rank "https://ratings.fide.com/top.phtml?list=men_blitz"

  def call(category \\ :standard) do
    url = get_url(category)
    Logger.info "Fetching data from: #{url}..."

    case HTTPoison.get(url, [], [ssl: [{:verify, :verify_none}]]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Floki.parse()
        |> Floki.find("table.contentpaneopen:nth-of-type(2) tr:nth-of-type(2) table tr")
        |> Enum.with_index(1)
        |> Enum.map(&map_data/1)
    end
  end

  defp get_url(category) do
    case category do
      :standard -> @stardard_rank
      :rapid -> @rapid_rank
      :blitz -> @blitz_rank
    end
  end

  defp map_data({{"tr", _attr, content}, index}) do
    case index do
     1 ->
      index # do nothing for table header row :)
     _ ->
      first_name = content |> get_first_name()
      last_name= content |> get_last_name()
      country = content |> get_country()
      birthyear = content |> get_birthyear()

      # NOTE: we can store stardard_rating and games as well, but let's try to
      # use ratings_importer service for this.

      player_attributes = %{
        first_name: first_name,
        last_name: last_name,
        country: country,
        birthyear: birthyear
      }

      changeset = Player.changeset(%Player{}, player_attributes)

      case Repo.insert(changeset) do
        {:ok, player} ->
          {:ok, player}
        {:error, changeset} ->
          Logger.info changeset_error_to_string(changeset)
          {:error, changeset}
      end
    end
  end

  defp get_first_name(content) do
    content
      |> Floki.find("td > a")
      |> Floki.text
      |> String.split(", ")
      |> Enum.at(1)
  end

  defp get_last_name(content) do
    content
      |> Floki.find("td > a")
      |> Floki.text
      |> String.split(", ")
      |> Enum.at(0)
  end

  defp get_country(content) do
    Enum.at(content, 3) |> elem(2) |> to_string |> String.trim
  end

  defp get_birthyear(content) do
    Enum.at(content, 6) |> elem(2) |> to_string |> String.trim |> Integer.parse |> elem(1)
  end

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
