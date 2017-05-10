defmodule Vr.Repo.Migrations.CreatePart do
  use Ecto.Migration

  def change do
    create table(:parts) do
      add :name, :string
      add :asset_id, references(:assets, on_delete: :nothing)

      timestamps()
    end
    create index(:parts, [:asset_id])

  end
end
