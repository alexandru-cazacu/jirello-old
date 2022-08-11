defmodule JirelloWeb.PageControllerTest do
  use JirelloWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~
             "<span class=\"block\">Scale your project management</span>"
  end
end
