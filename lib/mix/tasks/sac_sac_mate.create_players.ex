defmodule Mix.Tasks.SacSacMate.CreatePlayers do
  use Mix.Task
  require Logger

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Services.PlayerCreator

  def run(_) do
    Mix.Task.run "app.start"

    PlayerCreator.call

    players_created_count = length(Repo.all(Player))

    Logger.info """
    Created players: #{inspect players_created_count}
    """
  end
end
