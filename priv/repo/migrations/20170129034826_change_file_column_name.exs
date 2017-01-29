defmodule Vr.Repo.Migrations.ChangeFileColumnName do
  use Ecto.Migration

  def change do
    rename table(:files), :relitive, to: :relative
  end
end
