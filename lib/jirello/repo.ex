defmodule Jirello.Repo do
  use Ecto.Repo,
    otp_app: :jirello,
    adapter: Ecto.Adapters.Postgres
end
