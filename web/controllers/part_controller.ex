defmodule Vr.PartController do
  use Vr.Web, :controller

  alias Vr.Part

  def index(conn, _params) do
    parts = Repo.all(Part)
    render(conn, "index.json", parts: parts)
  end

  def create(conn, %{"part" => part_params}) do
    changeset = Part.changeset(%Part{}, part_params)

    case Repo.insert(changeset) do
      {:ok, part} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", part_path(conn, :show, part))
        |> render("show.json", part: part)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    part = Repo.get!(Part, id)
    render(conn, "show.json", part: part)
  end

  def update(conn, %{"id" => id, "part" => part_params}) do
    part = Repo.get!(Part, id)
    changeset = Part.changeset(part, part_params)

    case Repo.update(changeset) do
      {:ok, part} ->
        render(conn, "show.json", part: part)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    part = Repo.get!(Part, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(part)

    send_resp(conn, :no_content, "")
  end
end
