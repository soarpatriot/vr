defmodule Vr.HighlightTest do
  use Vr.ModelCase

  alias Vr.Highlight

  @valid_attrs %{post_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Highlight.changeset(%Highlight{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Highlight.changeset(%Highlight{}, @invalid_attrs)
    refute changeset.valid?
  end
end
