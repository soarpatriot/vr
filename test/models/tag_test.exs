defmodule Vr.TagTest do
  use Vr.ModelCase

  alias Vr.Tag

  @valid_attrs %{code: "some code", name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end
end
