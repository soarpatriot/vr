defmodule Vr.Repo.Migrations.AddParentToAssets do
  use Ecto.Migration

  def change do
    alter table(:assets) do 
      add :parent, :string
    end
  end

end
