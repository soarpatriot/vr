defmodule Vr.Post do
  use Vr.Web, :model
  schema "posts" do
    field :title, :string
    field :description, :string
    timestamps()
    belongs_to :user, Vr.User
    has_one :cover, Vr.Cover, on_delete: :delete_all
    has_one :asset, Vr.Asset, on_delete: :delete_all
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :title, :description])
    |> validate_required([:user_id, :title, :description])
  end

  def with_user_file(query) do 
    from q in query, preload: ([ :user, :asset, :cover ])
  end 
end
