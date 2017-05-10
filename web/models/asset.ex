defmodule Vr.Asset do
  use Vr.Web, :model

  schema "assets" do
    field :filename, :string
    field :mimetype, :string
    field :relative, :string
    field :full, :string
    field :size, :integer
    field :parent, :string

    timestamps()
    
    belongs_to :post, Vr.Post
    has_many :parts, Vr.Part, on_delete: :delete_all
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :filename, :mimetype, :relative, :full, :size, :parent])
    |> validate_required([:filename, :mimetype, :relative, :full, :size, :parent])
  end
end
