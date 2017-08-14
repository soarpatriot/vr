defmodule Vr.Session do
  use Vr.Web, :model
  alias Vr.User
  alias Vr.Repo
  
  def login(params) do 
    user = Repo.get_by(User, %{email: String.downcase(params["email"]), status: :active})
    case authenticated(user, params["password"]) do 
      true -> {:ok, user}
      _ -> {:error, "用户不存在或未激活！"}
    end
  end
  
  defp authenticated(user, password) do 
    case user do 
      nil -> false 
      _ -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def validate(params) do 
    v  = User.verify_token(params["token"])
    case v.error do 
      nil -> 
        v.claims
      _ ->
        %{error: "invalid"} 
    end
  end

end

