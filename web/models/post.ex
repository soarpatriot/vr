defmodule Vr.Post do
  use Vr.Web, :model
  alias Vr.File
  alias Vr.Repo
  schema "posts" do
    field :title, :string
    field :description, :string
    timestamps()
    belongs_to :user, Vr.User
    has_one :file, Vr.File
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :title, :description])
    |> validate_required([:user_id, :title, :description])
  end

  def insertassoc(params, file_params) do
    Repo.transaction(fn ->    
      i = changeset(params, :create)
        if i.valid? do
          Repo.insert(i)
        else
          Repo.rollback(i.errors)
        end

      insert_include = fn k ->
        c = File.changeset(k, :create)
        if c.valid? do
          Repo.insert(c)
        else
          Repo.rollback(c.errors)
        end
      end

      for include <- file_params do
        insert_include.(Map.merge(include, %{"post_id" => i.id}))
      end

    end)
  end
end
