defmodule Vr.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :code, :string
      add :name, :string

      timestamps()
    end
  end
end
