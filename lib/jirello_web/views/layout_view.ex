defmodule JirelloWeb.LayoutView do
  use JirelloWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def gravatar(email, class) do
    hash =
      email
      |> String.trim()
      |> String.downcase()
      |> :erlang.md5()
      |> Base.encode16(case: :lower)

    img = "https://www.gravatar.com/avatar/#{hash}?s=256&d=identicon"
    img_tag(img, class: class)
  end
end
