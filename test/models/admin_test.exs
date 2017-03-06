defmodule Vr.AdminTest do
  use Vr.ModelCase

  alias Vr.Admin

  @valid_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Admin.changeset(%Admin{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Admin.changeset(%Admin{}, @invalid_attrs)
    refute changeset.valid?
  end
end
