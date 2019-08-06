defmodule Mix.Tasks.SacSacMate.Stats do
  use Mix.Task
  require Logger
  alias SacSacMate.Repo
  alias SacSacMate.Accounts.Player
  alias SacSacMate.Player.Rating

  def run(_) do
    Mix.Task.run "app.start"

    player_count = Repo.aggregate(Player, :count, :id)
    rating_count = Repo.aggregate(Rating, :count, :id)

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
