defmodule Vr.Session do
  use Vr.Web, :model
  alias Vr.User
  
  def login(params, repo) do 
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticated(user, params["password"]) do 
      true -> {:ok, user}
      _ -> :error
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

