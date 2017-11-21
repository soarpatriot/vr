defmodule Vr.UserController do
  use Vr.Web, :controller
  alias Vr.User
  alias Vr.Post
  alias Vr.Asset


  #  import Ecto.Changeset, only: [put_change: 3]

  def index(conn, params) do
    page = User
            |> Repo.paginate(params)
    users = page.entries
    conn 
      |> Scrivener.Headers.paginate(page)
      |> render("index.json", users: users)
 
      #users = Repo.all(User)
      #render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params) 
    
    case Repo.insert(changeset) do
      {:ok, user} ->
        User.send_verify_email(user)
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
          {:ok, _} ->
            conn
              |> render(Vr.ChangesetView, "result.json", %{code: 0, msg: "验证成功，账号已激活！"})
          {:error, _} ->
            conn 
              |> render(Vr.ChangesetView, "result.json", %{code: 2, msg: "激活错误！"})
        end
      _  ->
        conn
          |> render(Vr.ChangesetView, "result.json", %{code: 1, msg: "验证码不正确或失效!"})
    end
  end

  def reactivation(conn, %{"email" => email}) do 
    # user = Vr.Repo.get_by(User, email: email)
    case Vr.Repo.get_by(User, email: email) do
      nil -> 
        conn |> render(Vr.ChangesetView, "result.json", %{code: 1, msg: "此邮箱未关联账号，请检查您的邮箱是否填写正确！"})
      user -> 
        case user.status do 
          :active -> 
            conn |> render(Vr.ChangesetView, "result.json", %{code: 2, msg: "邮箱未关联账号已经激活！"})
          _ ->
            User.send_verify_email(user)
            conn |> render(Vr.ChangesetView, "result.json", %{code: 0, msg: "已发送激活邮件到您的邮箱，5小时内有效，请注意查收！"})
        end
    end
  end

  def posts(conn, params) do
    user_id = params["id"]
    user = Repo.get!(User, user_id)
    page = Post |> where([p], p.user_id == ^user_id) 
            |> Repo.paginate(params)
    posts = page.entries
            |> Repo.preload([asset: :parts])
            |> Repo.preload([:user])
            |> Repo.preload([:tag])
            |> Repo.preload([:cover])
            |> Post.convert_time
    conn 
      |> Scrivener.Headers.paginate(page)
      |> render("user-posts.json", %{user: user,  posts: posts})
 

  end


end
