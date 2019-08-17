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

    # NOTE: This is not a best way to iterate over large collections
    Enum.each data, fn rating ->
      case Repo.get_by(Player, %{fideid: rating.fideid}) do
        nil  ->
          insert_player(rating)
        player ->
          # TODO:
          # We need to update existing player fide title here.

          # Idea:
          # If title was nil Then do update
          # If title was lower than current Then do update

          # Man titles ordered:   GM,  IM,  FM,  CM
          # Women titles ordered: WGM, WIM, WFM, WCM

          # Example:
          # If player was IM and we have CM Then do NOT update
          # If player was IM and we have GM Then do update

          player
      end
    end
  end

  defp insert_player(rating) do
    {first_name, last_name} = get_first_and_last_name(rating.name)

    player = Repo.insert!(%Player{
      fideid: rating.fideid,
      first_name: first_name,
      last_name: last_name,
      sex: rating.sex,
      country: rating.country,
      birthyear: rating.birthyear,
      # fide_title: rating.fide_title,
      # fide_women_title: rating.fide_women_title
    })

    changeset = Rating.changeset(rating,
      %{player_id: player.id}
    )

    Repo.update(changeset)
  end

  defp get_first_and_last_name(name) do
    separator = case name =~ ", " do
      true -> ", "
      false -> " "
    end
    first_name = name |> to_string() |> String.split(separator) |> Enum.at(1)
    last_name = name |> to_string() |> String.split(separator) |> Enum.at(0)

    {first_name, last_name}
  end
end
