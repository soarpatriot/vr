defmodule Vr.FileTest do
  use Vr.ModelCase

  alias Vr.File

  @valid_attrs %{post_id: 2, filename: "some content", full: "some content", mimetype: "some content", relative: "some content", size: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = File.changeset(%File{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = File.changeset(%File{}, @invalid_attrs)
    refute changeset.valid?
  end
end
