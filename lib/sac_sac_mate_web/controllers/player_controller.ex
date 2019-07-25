defmodule SacSacMateWeb.PlayerController do
  use SacSacMateWeb, :controller

  alias SacSacMate.Accounts
  alias SacSacMate.Accounts.Player

  plug(:put_layout, {SacSacMateWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Accounts.paginate_players(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Players. #{inspect(error)}")
        |> redirect(to: Routes.player_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_player(%Player{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"player" => player_params}) do
    case Accounts.create_player(player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player created successfully.")
        |> redirect(to: Routes.player_path(conn, :show, player))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    player = Accounts.get_player!(id)
    render(conn, "show.html", player: player)
  end

  def edit(conn, %{"id" => id}) do
    player = Accounts.get_player!(id)
    changeset = Accounts.change_player(player)
    render(conn, "edit.html", player: player, changeset: changeset)
  end

  def update(conn, %{"id" => id, "player" => player_params}) do
    player = Accounts.get_player!(id)

    case Accounts.update_player(player, player_params) do
      {:ok, player} ->
        conn
        |> put_flash(:info, "Player updated successfully.")
        |> redirect(to: Routes.player_path(conn, :show, player))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", player: player, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    player = Accounts.get_player!(id)
    {:ok, _player} = Accounts.delete_player(player)

    conn
    |> put_flash(:info, "Player deleted successfully.")
    |> redirect(to: Routes.player_path(conn, :index))
  end
end