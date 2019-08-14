defmodule SacSacMate.Services.BatchRatingImporterTest do

  use SacSacMateWeb.ConnCase
  alias SacSacMate.Services.BatchRatingImporter

  @tag timeout: :infinity
  test "stores data in DB" do
    dirname = "files/test/"
    ext = "*.xml"

    Path.wildcard("#{dirname}#{ext}")
    |> (Enum.map fn (file) ->
      BatchRatingImporter.call(file)
    end)
  end
end
