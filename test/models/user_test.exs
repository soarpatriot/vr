defmodule Vr.UserTest do
  use Vr.ModelCase

  alias Vr.User

  @valid_attrs %{email: "aaa@qq.com", name: "some content", password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "gen a valid token with user id" do 
    code = User.gen_verify(12121)
    result = User.verify_account(code)
    assert {:ok, _} = result
  end
end
