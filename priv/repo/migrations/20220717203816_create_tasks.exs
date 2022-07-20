defmodule Jirello.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :done, :boolean, default: false, null: false

      timestamps()
    end
  end
end
