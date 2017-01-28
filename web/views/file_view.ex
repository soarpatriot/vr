defmodule Vr.FileView do
  use Vr.Web, :view

  def render("index.json", %{files: files}) do
    %{data: render_many(files, Vr.FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, Vr.FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id,
      filename: file.filename,
      mimetype: file.mimetype,
      relitive: file.relitive,
      full: file.full,
      size: file.size}
  end
end
