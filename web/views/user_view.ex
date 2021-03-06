defmodule Vr.UserView do
  use Vr.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Vr.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Vr.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      status: user.status,
      avatar_url: user.avatar_url,
      inserted_at: Vr.Convert.native_to_timestamp(user.inserted_at)
    }
  end

  def render("user-posts.json", %{user: user, posts: posts}) do 
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      status: user.status,
      avatar_url: user.avatar_url,
      posts: render_many(posts, Vr.PostView, "post-with-assets.json")
    }
  end
  
  def render("token.json", %{token: token}) do 
    %{
      token: token
    }
  end
end
