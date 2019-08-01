defmodule Mix.Tasks.SacSacMate.Stats do
  use Mix.Task
  require Logger


  def run(_) do
    Mix.Task.run "app.start"

    player_count = length(SacSacMate.Repo.all(SacSacMate.Accounts.Player))
    rating_count = length(SacSacMate.Repo.all(SacSacMate.Player.Rating))

    Logger.info """
    Rating count: #{rating_count}
    """
    Logger.info """
    Player count: #{player_count}
    """
  end
end
