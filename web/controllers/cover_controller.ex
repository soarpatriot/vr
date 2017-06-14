defmodule Vr.CoverController do
  use Vr.Web, :controller

  alias Vr.Cover

  def index(conn, _params) do
    covers = Repo.all(Cover)
    render(conn, "index.json", covers: covers)
  end

  def create(conn, %{"cover" => cover_params}) do
    # changeset = Cover.changeset(%Cover{}, cover_params)
    IO.inspect cover_params["post_id"]
    result =  
      case is_nil(cover_params["post_id"]) do 
        false ->
          query = (Ecto.Query.from c in Cover, where: c.post_id == ^cover_params["post_id"])
          
          case  Repo.one(query) do 
            nil ->
              %Cover{}
            cover -> 
              cover  
          end  
        true ->
          %Cover{}
      end
        |> Cover.changeset(cover_params)
        |> Repo.insert_or_update

    case result do
      {:ok, cover} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cover_path(conn, :show, cover))
        |> render("show.json", cover: cover)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cover = Repo.get!(Cover, id)
    render(conn, "show.json", cover: cover)
  end

  def update(conn, %{"id" => id, "cover" => cover_params}) do
    cover = Repo.get!(Cover, id)
    changeset = Cover.changeset(cover, cover_params)

    case Repo.update(changeset) do
      {:ok, cover} ->
        render(conn, "show.json", cover: cover)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cover = Repo.get!(Cover, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cover)

    send_resp(conn, :no_content, "")
  end
end
