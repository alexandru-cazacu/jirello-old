defmodule Jirello.Repo.Migrations.UpdateUsersAddFirstnameLastname do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :text
      add :last_name, :text
    end
  end
end
