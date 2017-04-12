defmodule Vr.AssetController do
  use Vr.Web, :controller

  alias Vr.Asset

  def index(conn, _params) do
    assets = Repo.all(Asset)
    render(conn, "index.json", assets: assets)
  end

  def create(conn, %{"asset" => file_params}) do
    changeset = Asset.changeset(%Asset{}, file_params)

    case Repo.insert(changeset) do
      {:ok, asset} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", asset_path(conn, :show, asset))
        |> render("show.json", asset: asset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    asset = Repo.get!(Asset, id)
    render(conn, "show.json", asset: asset)
  end

  def update(conn, %{"id" => id, "asset" => file_params}) do
    asset = Repo.get!(Asset, id)
    changeset = Asset.changeset(asset, file_params)

    case Repo.update(changeset) do
      {:ok, asset} ->
        render(conn, "show.json", asset: asset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Vr.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    asset = Repo.get!(Asset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(asset)

    send_resp(conn, :no_content, "")
  end
end
