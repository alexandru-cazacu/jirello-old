defmodule Jirello.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jirello.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Jirello.Projects.create_project()

    project
  end
end
