defmodule JirelloWeb.ErrorView do
  use JirelloWeb, :view

  def template_not_found("500.html", assigns) do
    render("500.html", assigns)
  end

  def template_not_found("404.html", assigns) do
    render("404.html", assigns)
  end
end
