defmodule Jirello.Projects.Project do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> validate_length(:title, min: 2)
  end
end
