defmodule SacSacMate.Factory do
  use ExMachina.Ecto, repo: SacSacMate.Repo

  def player_factory do
    first_name = sequence(:first_name, &"First name (#{&1})")
    last_name = sequence(:last_name, &"Last name (#{&1})")

    %SacSacMate.Accounts.Player{
      fideid: sequence(:fideid, &"123#{&1}"),
      first_name: first_name,
      last_name: last_name,
      country: Enum.random(["POL", "HUN"]),
      birthyear: "1987"
    }
  end

  def rating_factory do
    standard_rating = sequence(:standard_rating, &"123#{&1}")
    rapid_rating= sequence(:rapid_rating, &"123#{&1}")
    blitz_rating = sequence(:blitz_rating, &"123#{&1}")

    %SacSacMate.Player.Rating{
      name: "Trojanowski, Rafal",
      country: "POL",
      fideid: sequence(:fideid, &"123#{&1}"),
      standard_rating: standard_rating,
      rapid_rating: rapid_rating,
      blitz_rating: blitz_rating,
      date: DateTime.utc_now,
      player: build(:player)
    }
  end
end
