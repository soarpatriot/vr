defmodule Vr.Repo.Migrations.AddSizeToParts do
  use Ecto.Migration

  def change do
    alter table(:parts) do 
      add :size, :integer
    end


  end
end
