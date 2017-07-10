defmodule Vr.Repo.Migrations.ModifyPostAssetCascade do
  use Ecto.Migration

  def up do 
     # drop_if_exists index(:assets, [:post_id])
     # drop constraint(:assets, name: "assets_post_id_fkey")
     # execute "ALTER TABLE assets DROP CONSTRAINT assets_post_id_fkey"
    alter table(:assets) do 
      modify :post_id, references(:posts, on_delete: :delete_all)
    end

  end

  def down do 
    execute "ALTER TABLE assets DROP CONSTRAINT assets_post_id_fkey"
    # drop_if_exists index(:assets, [:post_id])
    # drop constraint(:assets, name: "assets_post_id_fkey")
    alter table(:assets) do 
      modify :post_id, references(:posts, on_delete: :nothing)
    end

  end
end
