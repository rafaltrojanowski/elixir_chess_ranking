defmodule SacSacMate.Services.PlayerImporterTest do

  # use ExUnit.Case, async: true
  use SacSacMateWeb.ConnCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias SacSacMate.Accounts
  alias SacSacMate.Services.PlayerImporter

  alias SacSacMate.Accounts.Player
  alias SacSacMate.Repo

  setup_all do
    HTTPoison.start
  end

  test "imports players" do
    use_cassette "top_list_men" do
      data = PlayerImporter.call()
      assert length(Repo.all(Player)) ==  101
    end
  end
end
