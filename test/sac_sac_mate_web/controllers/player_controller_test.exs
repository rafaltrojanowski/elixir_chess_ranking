defmodule SacSacMateWeb.PlayerControllerTest do
  use SacSacMateWeb.ConnCase

  alias SacSacMate.Accounts

  @create_attrs %{fideid: 12345, country: "some country", birthyear: 1990, first_name: "some first_name", last_name: "some last_name"}
  @update_attrs %{fideid: 99999, country: "some updated country", birthyear: 2000, first_name: "some updated first_name", last_name: "some updated last_name"}
  @invalid_attrs %{country: nil, birthyear: nil, first_name: nil, last_name: nil}

  def fixture(:player) do
    {:ok, player} = Accounts.create_player(@create_attrs)
    player
  end

  describe "index" do
    test "lists all players", %{conn: conn} do
      conn = get conn, Routes.player_path(conn, :index)
      assert html_response(conn, 200) =~ "Players"
    end
  end

  describe "new player" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.player_path(conn, :new)
      assert html_response(conn, 200) =~ "New Player"
    end
  end

  describe "create player" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.player_path(conn, :create), player: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.player_path(conn, :show, id)

      conn = get conn, Routes.player_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Player Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.player_path(conn, :create), player: @invalid_attrs
      assert html_response(conn, 200) =~ "New Player"
    end
  end

  describe "edit player" do
    setup [:create_player]

    test "renders form for editing chosen player", %{conn: conn, player: player} do
      conn = get conn, Routes.player_path(conn, :edit, player)
      assert html_response(conn, 200) =~ "Edit Player"
    end
  end

  describe "update player" do
    setup [:create_player]

    test "redirects when data is valid", %{conn: conn, player: player} do
      conn = put conn, Routes.player_path(conn, :update, player), player: @update_attrs
      assert redirected_to(conn) == Routes.player_path(conn, :show, player)

      conn = get conn, Routes.player_path(conn, :show, player)
      assert html_response(conn, 200) =~ "some updated country"
    end

    test "renders errors when data is invalid", %{conn: conn, player: player} do
      conn = put conn, Routes.player_path(conn, :update, player), player: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Player"
    end
  end

  describe "delete player" do
    setup [:create_player]

    test "deletes chosen player", %{conn: conn, player: player} do
      conn = delete conn, Routes.player_path(conn, :delete, player)
      assert redirected_to(conn) == Routes.player_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.player_path(conn, :show, player)
      end
    end
  end

  defp create_player(_) do
    player = fixture(:player)
    {:ok, player: player}
  end
end
