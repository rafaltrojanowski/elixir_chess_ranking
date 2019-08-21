defmodule SacSacMate.Services.PlayerCreatorTest do

  use SacSacMateWeb.ConnCase
  import SacSacMate.Factory

  alias SacSacMate.Services.PlayerCreator
  alias SacSacMate.Accounts.Player
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
    insert(:rating,
      fideid: 123456,
      date: "2019-01-01",
      fide_title: nil,
      player: nil
    )
    insert(:rating,
      fideid: 123456,
      date: "2019-03-01",
      fide_title: "FM",
      player: nil
    )
    insert(:rating,
      fideid: 123456,
      date: "2019-04-01",
      fide_title: "GM",
      player: nil
    )

    PlayerCreator.call
    player = Repo.get_by!(Player, fideid: 123456)

    assert player.fide_title == "GM"
  end
end
