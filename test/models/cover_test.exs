defmodule Vr.CoverTest do
  use Vr.ModelCase

  alias Vr.Cover

  @valid_attrs %{filename: "some content", full: "some content", mimetype: "some content", parent: "some content", post_id: 42, size: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cover.changeset(%Cover{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cover.changeset(%Cover{}, @invalid_attrs)
    refute changeset.valid?
  end
end
