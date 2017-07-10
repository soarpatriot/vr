defmodule Vr.Repo.Migrations.ModifyAssetPartCascade do
  use Ecto.Migration

  def up do 
    execute "ALTER TABLE parts DROP CONSTRAINT parts_asset_id_fkey"
    # drop_if_exists index(:parts, [:asset_id])
    # drop_if_exists constraint(:parts, name: "parts_asset_id_fkey")
    alter table(:parts) do 
      modify :asset_id, references(:assets, on_delete: :delete_all)
    end

  end

  def down do 
    execute "ALTER TABLE parts DROP CONSTRAINT parts_asset_id_fkey"
    #  drop_if_exists index(:parts, [:asset_id])
    # drop_if_exists constraint(:parts, name: "parts_asset_id_fkey")
    alter table(:parts) do 
      modify :asset_id, references(:assets, on_delete: :nothing)
    end
  end

end
