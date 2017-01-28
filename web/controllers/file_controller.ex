defmodule Vr.FileController do
  use Vr.Web, :controller

  alias Vr.File

  def index(conn, _params) do
    files = Repo.all(File)
    render(conn, "index.json", files: files)
  end

  def create(conn, %{"file" => file_params}) do
    changeset = File.changeset(%File{}, file_params)

    case Repo.insert(changeset) do
      {:ok, file} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", file_path(conn, :show, file))
        |> render("show.json", file: file)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Repo.get!(File, id)
    render(conn, "show.json", file: file)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Repo.get!(File, id)
    changeset = File.changeset(file, file_params)

    case Repo.update(changeset) do
      {:ok, file} ->
        render(conn, "show.json", file: file)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Repo.get!(File, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(file)

    send_resp(conn, :no_content, "")
  end
end
