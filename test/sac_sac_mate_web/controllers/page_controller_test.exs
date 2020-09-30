defmodule SacSacMateWeb.PageControllerTest do
  use SacSacMateWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Admin"
  end
end
