defmodule Vr.User do
  use Vr.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end
  
  @required_fields ~w(name email password)
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end

  def hashed_password(password) do
    case password do 
      nil ->
        password
      _ ->
        Comeonin.Bcrypt.hashpwsalt(password)
    end
  end
end
