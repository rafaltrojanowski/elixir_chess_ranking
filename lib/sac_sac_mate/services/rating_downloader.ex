defmodule SacSacMate.Services.RatingDownloader do

  require Logger

  # TODO:
  # Handle better file not found case (dec 19, date is from future)
  # Generally FilesUnziper just skips unvalid filed, so it's not a big deal
  #

  @moduledoc """
    Traverse https://ratings.fide.com/download.phtml to grab chess rating history
    <a href="http://ratings.fide.com/download/standard_jul16frl.zip">TXT</a>
    <a href="http://ratings.fide.com/download/standard_jul16frl_xml.zip">XML</a>
  """

  @base_url "http://ratings.fide.com/download/"

  @categories ["standard", "rapid", "blitz"]
  @months ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
  @extension ".zip"

  @file_path "tmp/"

  def call(format \\ :xml) do
    Enum.each years_range, fn year ->
      year = year |> to_string |> String.slice(2..-1)

      Enum.each @months, fn month ->
        Enum.each @categories, fn category ->
          download build_link(format, category, month, year)
        end
      end
    end
  end

  defp download(link) do
    Logger.info """
    Downloading file from #{link} to #{@file_path}.
    """

    file_name = String.split(link, "/") |> Enum.at(-1)
    body = HTTPoison.get!(link, [], [recv_timeout: 300_000]).body

    File.mkdir_p!(Path.dirname(@file_path))
    File.write!("#{File.cwd!}/#{@file_path}#{file_name}", body)
  end

  defp build_link(format, category, month, year) do
    case format do
      :xml ->
        "#{@base_url}#{category}_#{month}#{year}frl_xml#{@extension}"
      :txt ->
        "#{@base_url}#{category}_#{month}#{year}frl#{@extension}"
    end
  end

  defp years_range do
    end_year = Date.utc_today().year
    start_year = end_year - 5
    start_year..end_year
  end
end
