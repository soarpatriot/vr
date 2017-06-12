defmodule Vr.CoverControllerTest do
  use Vr.ConnCase
  import Vr.Factory

  alias Vr.User
  alias Vr.Post
  alias Vr.Cover
  @valid_attrs %{filename: "some content", full: "some content", mimetype: "some content", parent: "some content", post_id: 42, size: 42}
  @invalid_attrs %{}

  setup do
    user = insert(:user)

    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
    {:ok, conn: conn, user: user, token: token} 
  end


  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cover_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    cover = Repo.insert! %Cover{}
    conn = get conn, cover_path(conn, :show, cover)
    assert json_response(conn, 200)["data"] == %{"id" => cover.id,
      "post_id" => cover.post_id,
      "filename" => cover.filename,
      "mimetype" => cover.mimetype,
      "full" => cover.full,
      "size" => cover.size,
      "parent" => cover.parent}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cover_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cover_path(conn, :create), cover: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cover, @valid_attrs)
  end

  test "update resource when post exist", %{conn: conn} do
    post = insert(:post)
    params = Map.merge(@valid_attrs,  %{post_id: post.id})
    IO.inspect params
    conn = post conn, cover_path(conn, :create), cover: params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cover, params)
    cover = Repo.get_by(Cover, params)
    assert cover.post_id == post.id
    # assert Repo.all(Cover)
    assert Repo.aggregate(Cover, :count, :id) == 1
  end


  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cover_path(conn, :create), cover: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cover = Repo.insert! %Cover{}
    conn = put conn, cover_path(conn, :update, cover), cover: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cover, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cover = Repo.insert! %Cover{}
    conn = put conn, cover_path(conn, :update, cover), cover: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    cover = Repo.insert! %Cover{}
    conn = delete conn, cover_path(conn, :delete, cover)
    assert response(conn, 204)
    refute Repo.get(Cover, cover.id)
  end
end
