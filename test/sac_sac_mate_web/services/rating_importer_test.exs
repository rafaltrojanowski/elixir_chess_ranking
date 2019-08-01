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
      fideid: "10207538",
      first_name: "Doshtagir",
      last_name: "A E M",
      country: "BAN"
    )

    RatingImporter.call(path)

    assert length(Repo.all(Player)) == 4
    assert length(Repo.all(Rating)) == 4

    player = Repo.get_by!(Player, fideid: "5093295")

    assert player.fideid == "5093295"
    assert player.first_name == nil
    assert player.last_name ==  "Aakasha"
    assert player.sex == "F"
    assert player.birthyear == 2000
    assert player.country == "IND"
  end
end
