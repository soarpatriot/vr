defmodule Vr.File do
  use Vr.Web, :model

  schema "files" do
    field :filename, :string
    field :mimetype, :string
    field :relitive, :string
    field :full, :string
    field :size, :integer

    timestamps()
    
    belongs_to :post, Vr.Post
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :filename, :mimetype, :relitive, :full, :size])
    |> validate_required([:post_id, :filename, :mimetype, :relitive, :full, :size])
  end
end
