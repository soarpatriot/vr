defmodule Vr.PartTest do
  use Vr.ModelCase

  alias Vr.Part

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Part.changeset(%Part{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Part.changeset(%Part{}, @invalid_attrs)
    refute changeset.valid?
  end
end
