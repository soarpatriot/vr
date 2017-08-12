defmodule Vr.UserControllerTest do
  use Vr.ConnCase
  import Vr.Factory

  alias Vr.User
  @valid_attrs %{email: "soarpatriot@126.com", name: "some content", password: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "name" => user.name,
      "email" => user.email}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    m = %{name: @valid_attrs[:name], email: @valid_attrs[:email]}
    assert Repo.get_by(User, m).crypted_password
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    m = %{name: @valid_attrs[:name], email: @valid_attrs[:email]}
    assert Repo.get_by(User, m)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  test "active user account", %{conn: conn} do 
    # IO.puts "111"
    user_params = %{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    changeset = User.registration_changeset(%User{}, user_params) 
    # ch = User.registration_changeset(changeset)
    # %User{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    # user = insert!(:user, status: :registered, crypted_password: 23423423423)
    # IO.inspect user
    user = Repo.insert! changeset 
    # IO.inspect user
    code = User.gen_verify(user.id)
    conn = get conn, user_path(conn, :activation), code: code
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 0
  end

  test "invalid active code", %{conn: conn} do 
    user_params = %{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    changeset = User.registration_changeset(%User{}, user_params) 
    # ch = User.registration_changeset(changeset)
    # %User{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    # user = insert!(:user, status: :registered, crypted_password: 23423423423)
    # IO.inspect user
    user = Repo.insert! changeset 
    # IO.inspect user
    code = User.gen_verify(user.id)
    conn = get conn, user_path(conn, :activation), code: "invalid"
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 1
 
  end
end
