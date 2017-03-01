defmodule Vr.Repo.Migrations.CreateHighlight do
  use Ecto.Migration

  def change do
    create table(:highlights) do
      add :post_id, :integer

      timestamps()
    end

  end
end
