defmodule Vr.SessionController do
  use Vr.Web, :controller
  alias Vr.User
  alias Vr.Session
  require IEx  
  def create(conn, %{"session" => session_params}) do 
    session = Session.login(session_params)  
    case session do 
      {:ok, user} ->
        token = User.generate_token(user)
        conn
          |> put_status(200)
          |> render("session.json", token: token)
          
      {:error, _ } -> 
        conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", msg: "邮箱或者密码错误, 或用户未激活！")
    end
  end

  def validate(conn, _params) do  
    user_id = conn.assigns.credentials["user_id"]
    user = Repo.get!(User, user_id)
    conn
    |> put_status(200)
    |> render(Vr.UserView,"user.json", user: user)
  end  
end
