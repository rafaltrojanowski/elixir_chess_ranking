defmodule SacSacMate.Services.BatchRatingImporterTest do

  use SacSacMateWeb.ConnCase
  alias SacSacMate.Services.BatchRatingImporter
  alias SacSacMate.Player.Rating
  alias SacSacMate.Repo

  @tag timeout: :infinity
  test "stores data in DB" do
    dirname = "files/test/one/"
    ext = "*.xml"

    Path.wildcard("#{dirname}#{ext}")
    |> (Enum.map fn (file) ->
      BatchRatingImporter.call(file)
    end)

    assert length(Repo.all(Rating)) == 100
  end
end
