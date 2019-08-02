defmodule SacSacMate.Services.RatingCollectionImporter do

  alias SacSacMate.Services.BatchRatingImporter

  @moduledoc """
    Import all ratings from dir
  """

  @ext "*.xml"

  # def call(dirname \\ 'files/xml/') do
  def call(dirname \\ 'fixture/files/') do
    Path.wildcard("#{dirname}#{@ext}")
    |> (Enum.map fn (file) ->
      BatchRatingImporter.call(file)
    end)
  end
end
