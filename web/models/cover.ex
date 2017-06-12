defmodule Vr.Cover do
  use Vr.Web, :model

  schema "covers" do
    # field :post_id, :integer
    field :filename, :string
    field :mimetype, :string
    field :full, :string
    field :size, :integer
    field :parent, :string

    belongs_to :post, Vr.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :filename, :mimetype, :full, :size, :parent])
    |> validate_required([:post_id, :filename, :mimetype, :full, :size, :parent])
  end
end
