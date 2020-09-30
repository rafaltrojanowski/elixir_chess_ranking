defmodule SacSacMateWeb.PlayersView do
  use JaSerializer.PhoenixView

  attributes [
    :id,
    :fideid,
    :first_name,
    :last_name,
    :country,
    :birthyear,
    :sex,
    :fide_title,
    :fide_women_title
  ]

end
