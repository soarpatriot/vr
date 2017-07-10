defmodule Vr.Repo.Migrations.ModifyPostCoverCascade do
  use Ecto.Migration

  def up do 
    # drop_if_exists index(:parts, [:asset_id])
    # drop_if_exists constraint(:parts, name: "parts_asset_id_fkey")
    alter table(:covers) do 
      modify :post_id, references(:posts, on_delete: :delete_all)
    end

  end

  def down do 
    execute "ALTER TABLE covers DROP CONSTRAINT covers_post_id_fkey"
    #  drop_if_exists index(:parts, [:asset_id])
    # drop_if_exists constraint(:parts, name: "parts_asset_id_fkey")
    alter table(:covers) do 
      modify :post_id, references(:posts, on_delete: :nothing)
    end
  end

end
