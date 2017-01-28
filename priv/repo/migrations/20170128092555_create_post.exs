defmodule Vr.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, :integer
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
