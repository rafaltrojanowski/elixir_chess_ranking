defmodule SacSacMateWeb.RatingController do
  use SacSacMateWeb, :controller

  alias SacSacMate.Player
  alias SacSacMate.Player.Rating

  plug(:put_layout, {SacSacMateWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case Player.paginate_ratings(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)
      error ->
        conn
        |> put_flash(:error, "There was an error rendering Ratings. #{inspect(error)}")
        |> redirect(to: Routes.rating_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = Player.change_rating(%Rating{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rating" => rating_params}) do
    case Player.create_rating(rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating created successfully.")
        |> redirect(to: Routes.rating_path(conn, :show, rating))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rating = Player.get_rating!(id)
    render(conn, "show.html", rating: rating)
  end

  def edit(conn, %{"id" => id}) do
    rating = Player.get_rating!(id)
    changeset = Player.change_rating(rating)
    render(conn, "edit.html", rating: rating, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rating" => rating_params}) do
    rating = Player.get_rating!(id)

    case Player.update_rating(rating, rating_params) do
      {:ok, rating} ->
        conn
        |> put_flash(:info, "Rating updated successfully.")
        |> redirect(to: Routes.rating_path(conn, :show, rating))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rating: rating, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rating = Player.get_rating!(id)
    {:ok, _rating} = Player.delete_rating(rating)

    conn
    |> put_flash(:info, "Rating deleted successfully.")
    |> redirect(to: Routes.rating_path(conn, :index))
  end
end