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

    insert(:player,
      first_name: "Doshtagir",
      last_name: "A E M",
      country: "BAN"
    )

    RatingImporter.call(path)

    assert length(Repo.all(Player)) == 4
    assert length(Repo.all(Rating)) == 4

    player = Repo.get_by!(Player,
      first_name: "Sourab",
      last_name: "A K M"
    )

    assert player.first_name == "Sourab"
    assert player.last_name ==  "A K M"
    assert player.sex == "M"
    assert player.birthyear == nil
    assert player.fideid == "10206612"
    assert player.country == "BAN"
  end
end
