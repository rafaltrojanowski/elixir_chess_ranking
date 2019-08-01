defmodule SacSacMate.Services.RatingCollectionImporter do

  alias SacSacMate.Services.RatingImporter

  @moduledoc """
    Import all ratings from dir
  """

  @ext "*.xml"

  def call(dirname \\ 'files/xml/') do
    Path.wildcard("#{dirname}#{@ext}")
    |> (Enum.map fn (file) ->
      RatingImporter.call(file)
    end)
  end
end
