defmodule Mix.Tasks.SacSacMate.Stats do
  use Mix.Task
  require Logger
  import Ecto.Query

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

    # Logger.info """
    # Inspect players with many rankings:
    # """
    # query = from r in "ratings",
          # group_by: r.player_id,
          # select: {r.player_id, count(r.id)},
          # order_by: [desc: count(r.id)]

    # result = SacSacMate.Repo.all(query)

    # IO.inspect result
  end
end
