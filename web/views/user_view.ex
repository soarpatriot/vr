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
      status: user.status
    }
  end
end
