defmodule Mix.Tasks.SacSacMate.ImportPlayers do
  use Mix.Task
  require Logger

  alias SacSacMate.Repo
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Services.PlayerImporter

  def run(_) do
    Mix.Task.run "app.start"

    PlayerImporter.call(:standard)
    PlayerImporter.call(:rapid)
    PlayerImporter.call(:blitz)

    players_imported_count = length(Repo.all(Player))

    Logger.info """
    Imported players: #{inspect players_imported_count}
    """
  end
end
