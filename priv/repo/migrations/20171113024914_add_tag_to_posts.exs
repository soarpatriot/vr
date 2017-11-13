defmodule Vr.Repo.Migrations.AddTagToPosts do
  use Ecto.Migration
  def change do
    alter table(:posts) do 
      add :tag_id, :integer
    end
  end
end
