defmodule Vr.Repo.Migrations.AddUniqueToUsers do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
    create unique_index(:users, [:name])
  end
end
