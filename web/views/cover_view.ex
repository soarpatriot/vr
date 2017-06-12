defmodule Vr.CoverView do
  use Vr.Web, :view

  def render("index.json", %{covers: covers}) do
    %{data: render_many(covers, Vr.CoverView, "cover.json")}
  end

  def render("show.json", %{cover: cover}) do
    %{data: render_one(cover, Vr.CoverView, "cover.json")}
  end

  def render("cover.json", %{cover: cover}) do
    %{id: cover.id,
      post_id: cover.post_id,
      filename: cover.filename,
      mimetype: cover.mimetype,
      full: cover.full,
      size: cover.size,
      parent: cover.parent}
  end
end
