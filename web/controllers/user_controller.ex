defmodule Vr.UserController do
  use Vr.Web, :controller
  alias Vr.User
  #  import Ecto.Changeset, only: [put_change: 3]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params) 
    
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  def activation(conn, %{"code" => code}) do 
    case User.verify_account(code) do 
      {:ok, claim } -> 
        user = Repo.get!(User, claim["user_id"])
        # changeset = User.changeset(user, %{status: :active})
        user = Ecto.Changeset.change user, status: :active

        case Repo.update(user) do 
          {:ok, user} ->
            conn
              |> render(Vr.ChangesetView, "result.json", %{code: 0, msg: "验证成功，账号已激活！"})
          {:error, user} ->
            conn 
             |> render(Vr.ChangesetView, "result.json", %{code: 2, msg: "激活错误！"})
        end
      _  ->
        conn
          |> render(Vr.ChangesetView, "result.json", %{code: 1, msg: "验证码不正确或失效!"})
    end
  end
end
