defmodule SacSacMate.Services.PlayerCreator do

  @moduledoc """
  Populates 'players' table based on 'ratings' table.
  Creates relationship between those two tables.
  """

  alias SacSacMate.Player.Rating
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Repo

  def call do
    data = Repo.all(Rating)

    Enum.each data , fn rating ->
      case Repo.get_by(Player, %{fideid: rating.fideid}) do
        nil  ->
          player = Repo.insert!(%Player{
            fideid: rating.fideid,
            first_name: rating.name, # TODO extract first_name
            last_name: rating.name, # TODO extract last_name
            sex: rating.sex,
            country: rating.country,
            birthyear: rating.birthyear
          })
          changeset = Rating.changeset(rating,
            %{player_id: player.id}
          )
          Repo.update(changeset)
        player -> player
      end
    end
  end
end
