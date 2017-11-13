defmodule Vr.TagView do
  use Vr.Web, :view

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, Vr.TagView, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, Vr.TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{id: tag.id,
      code: tag.code,
      name: tag.name}
  end
end
