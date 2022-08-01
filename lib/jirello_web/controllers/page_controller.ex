defmodule JirelloWeb.PageController do
  @moduledoc false

  use JirelloWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
