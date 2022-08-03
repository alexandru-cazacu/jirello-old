defmodule Jirello.Gravatar do
  @moduledoc false

  use JirelloWeb, :view

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
