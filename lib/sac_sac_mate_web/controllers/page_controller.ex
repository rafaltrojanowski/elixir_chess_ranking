defmodule SacSacMateWeb.PageController do
  use SacSacMateWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
