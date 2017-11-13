defmodule Vr.Post do
  use Vr.Web, :model

  @timestamps_opts [type: Timex.Ecto.DateTime,
                    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}]

  schema "posts" do
    field :title, :string
    field :description, :string
    field :from_now, :string, virtual: true
    timestamps()
    belongs_to :user, Vr.User
    belongs_to :tag, Vr.Tag
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

  def time_ago(post = %Vr.Post{}) do 
    ago = Timex.from_now(post.inserted_at)
    post = %Vr.Post{ post | from_now: ago}
  end

  def convert_time(posts) do 
    for p <- posts do 
      Vr.Post.time_ago(p)
    end
  end
end
