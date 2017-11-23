defmodule Vr.CommentView do
  use Vr.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Vr.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Vr.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      user_id: comment.user_id,
      post_id: comment.post_id,
      content: comment.content
    }
  end

  def render("com.json", %{comment: comment}) do
    %{id: comment.id,
      content: comment.content,
      user: render_one(comment.user, Vr.UserView, "user.json")
    }
  end


  def render("comments.json", %{comments: comments}) do 
    %{data: render_many(comments, Vr.CommentView, "com.json")}
  end

 
end
