defmodule Vr.Repo.Migrations.AddPostIdToFiles do
  use Ecto.Migration

  def change do
    alter table(:files) do 
      add :post_id, :integer
    end
  end
end
