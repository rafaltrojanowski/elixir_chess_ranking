defmodule SacSacMate.AccountsTest do
  use SacSacMate.DataCase

  alias SacSacMate.Accounts

  describe "players" do
    alias SacSacMate.Accounts.Player

    @valid_attrs %{country: "some country", date_of_birth: "some date_of_birth", first_name: "some first_name", last_name: "some last_name"}
    @update_attrs %{country: "some updated country", date_of_birth: "some updated date_of_birth", first_name: "some updated first_name", last_name: "some updated last_name"}
    @invalid_attrs %{country: nil, date_of_birth: nil, first_name: nil, last_name: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_player()

      player
    end

    test "paginate_players/1 returns paginated list of players" do
      for _ <- 1..20 do
        player_fixture()
      end

      {:ok, %{players: players} = page} = Accounts.paginate_players(%{})

      assert length(players) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Accounts.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Accounts.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Accounts.create_player(@valid_attrs)
      assert player.country == "some country"
      assert player.date_of_birth == "some date_of_birth"
      assert player.first_name == "some first_name"
      assert player.last_name == "some last_name"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Accounts.update_player(player, @update_attrs)
      assert %Player{} = player
      assert player.country == "some updated country"
      assert player.date_of_birth == "some updated date_of_birth"
      assert player.first_name == "some updated first_name"
      assert player.last_name == "some updated last_name"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_player(player, @invalid_attrs)
      assert player == Accounts.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Accounts.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Accounts.change_player(player)
    end
  end
end
