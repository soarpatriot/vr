defmodule Vr.Comment do
  use Vr.Web, :model

  schema "comments" do
    belongs_to :post, Vr.Post
    belongs_to :user, Vr.User
    field :content, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id, :content])
    |> validate_required([:user_id, :post_id, :content])
  end
end
