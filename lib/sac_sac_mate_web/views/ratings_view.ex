defmodule SacSacMateWeb.RatingsView do
  use SacSacMateWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :id,
    :standard_rating,
    :rapid_rating,
    :blitz_rating,
    :standard_games,
    :rapid_games,
    :blitz_games,
    :standard_k_factor,
    :rapid_k_factor,
    :blitz_k_factor,
    :fideid,
    :name,
    :country,
    :sex,
    :fide_title,
    :fide_women_title,
    :birthyear,
    :date
  ]

  has_one :player, 
    serializer: SacSacMateWeb.PlayersView,
    include: true

  def player(struct, conn) do
    case struct.player do
      %Ecto.Association.NotLoaded{} -> %SacSacMate.Accounts.Player{id: struct.player_id}
      other -> other
    end
  end
end
