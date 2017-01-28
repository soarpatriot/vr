defmodule Vr.PostView do
  use Vr.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Vr.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Vr.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      user_id: post.user_id,
      title: post.title,
      description: post.description}
  end
end
