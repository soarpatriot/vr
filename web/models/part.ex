defmodule Vr.Part do
  use Vr.Web, :model

  schema "parts" do
    field :name, :string
    belongs_to :asset, Vr.Asset

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def list([head | tail]) do 
    [Ecto.Changeset.change(%Vr.Part{},name: head) | list(tail) ] 
  end

  def list([]) do 
    []
  end

  def list(nil) do 
    []
  end
end
