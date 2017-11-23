defmodule Vr.CommentController do
  use Vr.Web, :controller

  alias Vr.Comment

  def index(conn, params) do
    page = Comment
            |> Repo.paginate(params)
    comments = page.entries
            |> Repo.preload([:user])
            |> Repo.preload([:post])
    conn 
      |> Scrivener.Headers.paginate(page)
      |> render("index.json", comments: comments)
 
    #comments = Repo.all(Comment)
    #render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    user_id = conn.assigns.credentials["user_id"]
    changeset = Comment.changeset(%Comment{}, comment_params)
                |> Ecto.Changeset.change(%{user_id: user_id})
    
    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_path(conn, :show, comment))
        |> render("show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(comment)

    send_resp(conn, :no_content, "")
  end
end
