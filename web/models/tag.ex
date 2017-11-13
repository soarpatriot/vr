defmodule Vr.Tag do
  use Vr.Web, :model

  schema "tags" do
    field :code, :string
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code, :name])
    |> validate_required([:code, :name])
  end
end
