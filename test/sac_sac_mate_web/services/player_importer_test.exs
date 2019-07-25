defmodule SacSacMate.Services.CommentCreatorTest do

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias SacSacMate.Services.PlayerImporter

  setup_all do
    HTTPoison.start
  end

  test "imports players" do
    # TODO Add some real tests
    use_cassette "top_list_men" do
      PlayerImporter.call()
    end
  end
end
