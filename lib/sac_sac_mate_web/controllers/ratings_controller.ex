defmodule SacSacMateWeb.RatingsController do
  use SacSacMateWeb, :controller

  alias SacSacMate.Repo
  alias SacSacMate.Player.Rating

  def index(conn, _params) do
    render conn, "index.json-api", data: Repo.all(Rating)
  end

  def show(conn, %{"id" => id}) do
    rating = Repo.get(Rating, id)
    render conn, "show.json-api", data: rating
  end
end
