defmodule SacSacMate.Factory do
  use ExMachina.Ecto, repo: SacSacMate.Repo

  def player_factory do
    first_name = sequence(:first_name, &"First name (#{&1})")
    last_name = sequence(:last_name, &"Last name (#{&1})")

    %SacSacMate.Accounts.Player{
      first_name: first_name,
      last_name: last_name,
      country: Enum.random(["POL", "HUN"]),
      date_of_birth: "1987"
    }
  end

  def rating_factory do
    standard_rating = sequence(:standard_rating, &"123#{&1}")
    rapid_ranking= sequence(:rapid_ranking, &"123#{&1}")
    blitz_ranking = sequence(:blitz_ranking, &"123#{&1}")

    %SacSacMate.Player.Rating{
      standard_rating: standard_rating,
      rapid_ranking: rapid_ranking,
      blitz_ranking: blitz_ranking,
      date: DateTime.utc_now,
      player: build(:player)
    }
  end
end
