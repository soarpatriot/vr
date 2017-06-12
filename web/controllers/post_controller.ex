defmodule Vr.PostController do
  use Vr.Web, :controller
  alias Vr.Post
  alias Vr.Asset

  def index(conn, params) do
    page = Post
            |> Repo.paginate(params)
    posts = page.entries
            |> Repo.preload([asset: :parts])
            |> Repo.preload([:user])
            |> Repo.preload([:cover])
    conn 
      |> Scrivener.Headers.paginate(page)
      |> render("index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user_id = conn.assigns.credentials["user_id"]
    # params = Map.merge(post_params, %{user_id: user_id})
    asset_id = post_params["file_id"]
	  changeset = Post.changeset(%Post{user_id: user_id}, post_params)
    case is_nil(asset_id) do 
      false ->
        # asset = Asset |> where([f], f.id in ^file_params) |> Repo.all
        asset = Asset |> Repo.get(asset_id) 
        # file_changeset = File.changeset(%File{}, file_params)
        # IO.inspect files
          case Repo.insert(changeset) do
					  {:ok, post} ->

              post 
                |> Repo.preload(:asset)
                |> Ecto.Changeset.change()
                |> Ecto.Changeset.put_assoc(:asset, asset)
                |> Repo.update!
                |> Repo.preload([:asset, :user])
              conn
                |> put_status(:created)
                |> put_resp_header("location", post_path(conn, :show, post))
                |> render("show.json", post: post)
            {:error, changeset} ->
               conn
                |> put_status(:unprocessable_entity)
                |> render(Vr.ChangesetView, "error.json", changeset: changeset)
          end  

      true ->
        error_changes = Ecto.Changeset.add_error(changeset, :file, "empty", additional: "file should not be empty")
 				conn
				  |> put_status(:unprocessable_entity)
					|> render(Vr.ChangesetView, "error.json", changeset: error_changes)
    end 
   # end 
  end


  def show(conn, %{"id" => id}) do
    post = Post  
            |> preload([asset: :parts])
            |> preload(:user)
            |> preload([:cover])
            |> Repo.get!(id)
    # render(conn, "show.json", post: post)
    render(conn, "show-extra.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    user_id = conn.assigns.credentials["user_id"]
    # post = Repo.get!(Post, id)
    # query = from p in Post, where: [id: ^id, user_id: ^user_id]
    #post = Repo.one |> where([p], p.id == id, p.user_id == user_id)
    post = Post 
              |> Post.with_user_file
              |> Repo.get_by(%{id: id, user_id: user_id})
    if is_nil(post) do 
      conn
        |> put_status(:not_found)
        |> render(Vr.ChangesetView, "not_found.json", msg: "无此post")
   
    else 
      changeset = Post.changeset(post, post_params)

      case Repo.update(changeset) do
        {:ok, post} ->
          render(conn, "show-extra.json", post: post)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Vr.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end

  def my(conn, params) do 
    user_id = conn.assigns.credentials["user_id"]
    page = Post |> where([p], p.user_id == ^user_id) 
             # Repo.get_by(Post, user_id: user_id)
            |> Repo.paginate(params)
    posts = page.entries
            |> Repo.preload([asset: :parts])
            |> Repo.preload([:user])
            |> Repo.preload([:cover])
    conn 
      |> Scrivener.Headers.paginate(page)
      |> render("index.json", posts: posts)
 
  end
end
