defmodule SacSacMate.Services.RatingImporterTest do

  use SacSacMateWeb.ConnCase
  import SacSacMate.Factory
  alias SacSacMate.Services.RatingImporter
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Player.Rating
  alias SacSacMate.Repo

  test "adds rating for existing player or creates player with rating" do
    file_name = "standard_feb14frl_xml_short.xml"
    path = "fixture/files/#{file_name}"

    player = insert(:player,
      first_name: "Doshtagir",
      last_name: "A E M",
      country: "BAN"
    )

    RatingImporter.call(path)

    assert length(Repo.all(Player)) == 2
    assert length(Repo.all(Rating)) == 2
  end
end
