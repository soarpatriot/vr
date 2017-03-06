defmodule Vr.Repo.Migrations.CreateAdmin do
  use Ecto.Migration

  def change do
    create table(:admins) do
      add :name, :string
      add :email, :string

      timestamps()
    end

  end
end
