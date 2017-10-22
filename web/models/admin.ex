defmodule Vr.Admin do
  use Vr.Web, :model
  use Coherence.Schema

  schema "admins" do
    field :name, :string
    field :email, :string
    coherence_schema

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email] ++ coherence_fields)  # Add this
    # |> cast(params, [:name, :email])
    |> validate_required([:name, :email ])
    |> validate_coherence(params)  
  end

  def changeset(model, params, :password) do
    model
    |> cast(params, ~w(password password_confirmation reset_password_token reset_password_sent_at))
    |> validate_coherence_password_reset(params)
  end
end
