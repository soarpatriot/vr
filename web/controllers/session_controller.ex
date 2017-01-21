defmodule Vr.SessionController do
  use Vr.Web, :controller
  alias Vr.User
  alias Vr.Session
  
  def create(conn, %{"session" => session_params}) do 
    session = Session.login(session_params, Vr.Repo)  
    case session do 
      {:ok, user} ->
        token = User.generate_token(user)
        conn
          |> put_status(200)
          |> render("session.json", token: token)
          
      :error -> 
        conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", message: "用户名密码错误!")
    end
  end

  def validate(conn, params) do  
    user = Repo.get!(User, params["user_id"])
    conn
    |> put_status(200)
    |> render(Vr.UserView,"user.json", user: user)
  end  
end
