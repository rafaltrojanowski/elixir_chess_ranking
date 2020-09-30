defmodule SacSacMate.Services.FilesUnziper  do

  @moduledoc """
    Unzip all files from dir
  """

  @ext "*.zip"

  def call(dirname \\ 'tmp/') do
    Path.wildcard("#{dirname}#{@ext}")
    |> (Enum.map fn (file) ->
      # IO.inspect file
      command = :zip.unzip(~c"#{file}", [{:cwd, 'files/xml/'}])

      case command do
        {:ok, path} ->
          IO.inspect path
        {:error, reason} ->
          IO.inspect reason
      end
    end)
  end
end
