defmodule JirelloWeb.PageControllerTest do
  use JirelloWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~
             "<p class=\"mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl\">Work redefined</p>"
  end
end
