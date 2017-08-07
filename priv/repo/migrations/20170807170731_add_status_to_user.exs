defmodule Vr.Repo.Migrations.AddStatusToUser do
  use Ecto.Migration

  def change do
    StatusEnum.create_type
    alter table(:users) do 
      add :status, :status
    end
  end
end
