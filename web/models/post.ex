defmodule Vr.Post do
  use Vr.Web, :model

  schema "posts" do
    field :title, :string
    field :description, :string
    timestamps()
    belongs_to :user, Vr.User
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :title, :description])
    |> validate_required([:user_id, :title, :description])
  end

end
