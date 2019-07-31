defmodule Mix.Tasks.SacSacMate.UnzipFiles do
  use Mix.Task
  require Logger

  alias SacSacMate.Services.FilesUnziper

  def run(_) do
    Mix.Task.run "app.start"
    FilesUnziper.call

    Logger.info """
    Unziped all files.
    """
  end
end
