defmodule JirelloWeb.PageController do
  use JirelloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
