defmodule Vr.Repo.Migrations.AddMurlToAsset do
  use Ecto.Migration

  def change do
    alter table(:assets) do 
      add :murl, :string
    end
  end
end
