defmodule JirelloWeb.StatsControllerTest do
  use JirelloWeb.ConnCase, async: true

  test "GET /open", %{conn: conn} do
    conn = get(conn, "/open")

    assert html_response(conn, 200) =~ ">Public Metrics</h2>"
  end
end
