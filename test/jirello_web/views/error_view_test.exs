defmodule JirelloWeb.ErrorViewTest do
  use JirelloWeb.ConnCase, async: true
  use Plug.Test

  # Bring user_fixture/0
  import Jirello.AccountsFixtures

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  # See https://www.munich-made.com/2020/03/20200304220507-testing-custom-errorview-in-phoenix/
  setup do
    user = user_fixture()

    conn =
      conn(:get, "/something")
      |> Plug.Conn.put_private(:phoenix_endpoint, JirelloWeb.Endpoint)
      |> Plug.Test.init_test_session(current_user_id: user.id)

    {:ok, conn: conn, user: user}
  end

  test "renders 404.html", %{conn: conn, user: user} do
    assert render_to_string(JirelloWeb.ErrorView, "404.html",
             conn: conn,
             current_user: user
           ) =~
             ">Page not found</h1>"
  end

  test "renders 500.html", %{conn: conn, user: user} do
    assert render_to_string(JirelloWeb.ErrorView, "500.html",
             conn: conn,
             current_user: user
           ) =~
             ">Internal Server Error</h1>"
  end
end
