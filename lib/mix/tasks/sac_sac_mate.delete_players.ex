defmodule Mix.Tasks.SacSacMate.DeletePlayers do
  use Mix.Task
  require Logger

  alias SacSacMate.Repo
  alias SacSacMate.Accounts.Player

  def run(_) do
    Mix.Task.run "app.start"

    # Tisabling constraints to be able to purge all table
    Ecto.Adapters.SQL.query!(Repo, "ALTER TABLE players DISABLE TRIGGER ALL;")
    Repo.delete_all(Player)
    Ecto.Adapters.SQL.query!(Repo, "ALTER TABLE players ENABLE TRIGGER ALL;")

    players_count = length(Repo.all(Player))
    Logger.info """
    Players has been deleted.
    #{players_count}
    """
  end
end
