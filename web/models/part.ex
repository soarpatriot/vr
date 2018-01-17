defmodule Vr.Part do
  use Vr.Web, :model

  schema "parts" do
    field :name, :string
    field :size, :integer
    belongs_to :asset, Vr.Asset

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :size])
    |> validate_required([:name, :size])
  end

  def list([head | tail]) do 
    [changeset(%Vr.Part{}, head) | list(tail) ]
    #  [Ecto.Changeset.change(%Vr.Part{},name: head, size: ) | list(tail) ] 
  end

  def list([]) do 
    []
  end

  def list(nil) do 
    []
  end
end
