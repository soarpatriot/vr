defmodule Vr.User do
  use Vr.Web, :model
  import Joken

  schema "users" do
    field :name, :string
    field :email, :string
    field :crypted_password, :string
    field :status, StatusEnum, default: :registered
    field :password, :string, virtual: true
    has_many :comments, Vr.Comment
    timestamps()
  end
  
  @required_fields ~w(name email password)
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :status])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> unique_constraint(:name)
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> put_password_hash
  end
 
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :crypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  def generate_token(user) do  
    %{user_id: user.id}
    |> token
    |> with_validation("user_id", &(&1 == 1))
    |> with_signer(hs256("my-loved-vr"))
    |> sign
    |> get_compact
  end
  
  def verify_token(token_str) do 
    token_str
      |> token
      |> with_signer(hs256("my-loved-vr"))
      |> verify 
  end
  
  def send_verify_email(user) do
    code = gen_verify(user.id)
    verify_url = "#{Application.get_env(:vr, Vr.Assets)[:host_url]}/#/activation?code=#{code}"
    Vr.Email.validate_html_email(user.email, verify_url, user.name) |> Vr.Mailer.deliver_later
  end
  def gen_verify(user_id) do 
    # 3600s * 5
     %{user_id: user_id, exp: current_time()+ 3600 * 5} 
      |> token
      |> with_signer(hs256("my_loved_code"))
      |> sign
      |> get_compact 
  end
 
  def verify_account(code) do
    code 
      |> token 
      |> with_validation("exp", &(&1 > current_time()))
      |> with_signer(hs256("my_loved_code"))
      |> verify!
  end
end
