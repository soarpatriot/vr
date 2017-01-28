defmodule Vr.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :filename, :string
      add :mimetype, :string
      add :relitive, :string
      add :full, :string
      add :size, :integer

      timestamps()
    end

  end
end
