defmodule Mix.Tasks.SacSacMate.ImportRatings do
  use Mix.Task
  require Logger

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  alias SacSacMate.Services.RatingCollectionImporter

  def run(_) do
    Mix.Task.run "app.start"

    RatingCollectionImporter.call

    ratings_imported_count = length(Repo.all(Rating))
    Logger.info """
    Imported ratings: #{inspect ratings_imported_count}
    """
  end
end
