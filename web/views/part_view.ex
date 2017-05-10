defmodule Vr.PartView do
  use Vr.Web, :view

  def render("index.json", %{parts: parts}) do
    %{data: render_many(parts, Vr.PartView, "part.json")}
  end

  def render("show.json", %{part: part}) do
    %{data: render_one(part, Vr.PartView, "part.json")}
  end

  def render("part.json", %{part: part}) do
    %{id: part.id,
      name: part.name}
  end
end
