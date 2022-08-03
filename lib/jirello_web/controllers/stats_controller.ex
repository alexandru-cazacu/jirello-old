defmodule JirelloWeb.StatsController do
  use JirelloWeb, :controller

  alias Jirello.Accounts

  def index(conn, _params) do
    users = Accounts.count()
    render(conn, "index.html", users: users)
  end
end
