defmodule Vr.PostView do
  use Vr.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Vr.PostView, "post-with-assoc.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Vr.PostView, "post.json")}
  end
  def render("show-extra.json", %{post: post}) do
    %{data: render_one(post, Vr.PostView, "post-with-assoc.json")}
  end

  def render("post-with-assoc.json", %{post: post}) do
    base =  %{id: post.id,
          user_id: post.user_id,
          title: post.title,
          description: post.description,
          from_now: post.from_now,
          cover: render_one(post.cover, Vr.CoverView, "show.json"),
          asset: render_one(post.asset, Vr.AssetView, "simple-file.json")}

    tag = 
      case !is_nil(post.tag) do 
        true ->
          %{tag: %{
            code: post.tag.code,
            name: post.tag.name
          }}
        false -> 
          %{}
      end

    user = 
      case !is_nil(post.user) do 
        true ->
          %{
            user_name: post.user.name,
            email: post.user.email
          }
        false -> 
          %{}
   
      end
      # Map.merge(base, file) |> Map.merge(user)
      Map.merge(base, user) |> Map.merge(tag)
  end
  def render("post-with-assets.json", %{post: post}) do
    base =  %{id: post.id,
          title: post.title,
          description: post.description,
          from_now: post.from_now,
          cover: render_one(post.cover, Vr.CoverView, "show.json"),
          asset: render_one(post.asset, Vr.AssetView, "simple-file.json")}

    tag = 
      case !is_nil(post.tag) do 
        true ->
          %{tag: %{
            code: post.tag.code,
            name: post.tag.name
          }}
        false -> 
          %{}
      end

    Map.merge(base, tag)
  end


  def render("post.json", %{post: post}) do
    %{id: post.id,
          user_id: post.user_id,
          title: post.title,
          description: post.description}
  end

  def render("show-file.json", %{asset: asset}) do 
    %{
       full: asset.full,
       murl: asset.murl,
       mimetype: asset.mimetype
    }
  end


end
