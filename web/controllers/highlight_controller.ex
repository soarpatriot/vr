defmodule Vr.HighlightController do
  use Vr.Web, :controller

  alias Vr.Highlight
  alias Vr.Post

  def index(conn, _params) do
    highlights = Repo.all(Highlight)
    render(conn, "index.json", highlights: highlights)
  end

  def create(conn, %{"highlight" => highlight_params}) do
    changeset = Highlight.changeset(%Highlight{}, highlight_params)

    case Repo.insert(changeset) do
      {:ok, highlight} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", highlight_path(conn, :show, highlight))
        |> render("show.json", highlight: highlight)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    highlight = Repo.get!(Highlight, id)
    render(conn, "show.json", highlight: highlight)
  end

  def update(conn, %{"id" => id, "highlight" => highlight_params}) do
    highlight = Repo.get!(Highlight, id)
    changeset = Highlight.changeset(highlight, highlight_params)

    case Repo.update(changeset) do
      {:ok, highlight} ->
        render(conn, "show.json", highlight: highlight)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    highlight = Repo.get!(Highlight, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(highlight)

    send_resp(conn, :no_content, "")
  end
   
  def lastest(conn, _params) do 
    highlight = Repo.one(from x in Highlight, order_by: [desc: x.id], limit: 1)
    post = Post 
            |> preload(:assets) 
            |> preload(:user)
            |> Repo.get!(highlight.post_id) 
    # render(conn, "show.json", post: post)
    render(conn, Vr.PostView, "show-extra.json", post: post)

  end
end
