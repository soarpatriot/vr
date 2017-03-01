defmodule Vr.HighlightView do
  use Vr.Web, :view

  def render("index.json", %{highlights: highlights}) do
    %{data: render_many(highlights, Vr.HighlightView, "highlight.json")}
  end

  def render("show.json", %{highlight: highlight}) do
    %{data: render_one(highlight, Vr.HighlightView, "highlight.json")}
  end
  def render("show-extra.json", %{post: post}) do
    %{data: render_one(post, Vr.PostView, "show-extra.json")}
  end


  def render("highlight.json", %{highlight: highlight}) do
    %{id: highlight.id,
      post_id: highlight.post_id}
  end
end
