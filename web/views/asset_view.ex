defmodule Vr.AssetView do
  use Vr.Web, :view

  def render("index.json", %{assets: assets}) do
    %{data: render_many(assets, Vr.AssetView, "file.json")}
  end

  def render("show.json", %{asset: asset}) do
    %{data: render_one(asset, Vr.AssetView, "file.json")}
  end

  def render("file.json", %{asset: asset}) do
    %{id: asset.id,
      filename: asset.filename,
      mimetype: asset.mimetype,
      relative: asset.relative,
      full: asset.full,
      size: asset.size}
  end
  def render("simple-file.json", %{asset: asset}) do
    %{
      id: asset.id,
      mimetype: asset.mimetype,
      full: asset.full
    }
  end

end
