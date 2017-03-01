defmodule Vr.Highlight do
  use Vr.Web, :model

  schema "highlights" do

    timestamps()
    belongs_to :post, Vr.Post
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id])
    |> validate_required([:post_id])
  end
end
