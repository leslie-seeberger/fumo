defmodule FumoWeb.PageControllerTest do
  use FumoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Fumo"
  end
end
