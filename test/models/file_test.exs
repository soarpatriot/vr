defmodule Vr.AssetTest do
  use Vr.ModelCase

  alias Vr.Asset

  @valid_attrs %{post_id: 2, filename: "some content", full: "some content", mimetype: "some content", relative: "some content", size: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Asset.changeset(%Asset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Asset.changeset(%Asset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
