defmodule Mix.Tasks.SacSacMate.DownloadRatings do
  use Mix.Task
  require Logger

  alias SacSacMate.Services.RatingDownloader

  def run(_) do
    Mix.Task.run "app.start"

    RatingDownloader.call

    Logger.info """
    Download done.
    """
  end
end
