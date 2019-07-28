defmodule Mix.Tasks.SacSacMate.ImportRatings do
  use Mix.Task
  require Logger

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating
  alias SacSacMate.Services.RatingImporter

  def run(_) do
    Mix.Task.run "app.start"

    example_file = "fixture/files/standard_feb14frl_xml.xml"
    RatingImporter.call(example_file)

    ratings_imported_count = length(Repo.all(Rating))

    Logger.info """
    Imported ratings: #{inspect ratings_imported_count}
    """
  end
end
