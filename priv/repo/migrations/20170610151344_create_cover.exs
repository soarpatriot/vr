defmodule Vr.Repo.Migrations.CreateCover do
  use Ecto.Migration

  def change do
    create table(:covers) do
      add :post_id, :integer
      add :filename, :string
      add :mimetype, :string
      add :full, :string
      add :size, :integer
      add :parent, :string

      timestamps()
    end

  end
end
