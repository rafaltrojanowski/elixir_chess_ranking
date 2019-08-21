defmodule SacSacMate.Services.PlayerCreatorTest do

  use SacSacMateWeb.ConnCase
  import SacSacMate.Factory

  alias SacSacMate.Services.PlayerCreator
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Player.Rating
  alias SacSacMate.Repo

  test "creates players from ratings" do
    insert(:rating,
      fideid: 123456,
      date: "2019-01-01",
      player: nil
    )
    insert(:rating,
      fideid: 123456,
      date: "2019-02-01",
      player: nil
    )
    insert(:rating, player: nil)

    PlayerCreator.call
    assert length(Repo.all(Player)) == 2
  end

  test 'stores correct fide title from ranking' do
    rating_1 = insert(:rating,
      fideid: 123456,
      date: "2019-01-01",
      fide_title: nil,
      player: nil
    )
    rating_2 = insert(:rating,
      fideid: 123456,
      date: "2019-03-01",
      fide_title: "FM",
      player: nil
    )
    rating_3 = insert(:rating,
      fideid: 123456,
      date: "2019-04-01",
      fide_title: "GM",
      fide_women_title: "WGM",
      player: nil
    )

    PlayerCreator.call
    player = Repo.get_by!(Player, fideid: 123456)

    assert player.fide_title == "GM"
    assert player.fide_women_title == "WGM"

    Repo.all(Rating)

    rating_1_updated = Repo.get(Rating, rating_1.id)
    rating_2_updated = Repo.get(Rating, rating_2.id)
    rating_3_updated = Repo.get(Rating, rating_3.id)

    assert rating_1_updated.player_id == player.id
    assert rating_2_updated.player_id == player.id
    assert rating_3_updated.player_id == player.id
  end
end
