defmodule Vr.Repo.Migrations.RenameFiles do
  use Ecto.Migration

  def change do
    rename table(:files), to: table(:assets)
  end
end
