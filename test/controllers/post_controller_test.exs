defmodule Vr.PostControllerTest do
  use Vr.ConnCase
  import Vr.Factory

  alias Vr.User
  alias Vr.Post
  @invalid_attrs %{}
  @valid_attrs %{description: "some content", title: "some content", user_id: 11} 
  @file_attrs  %{ filename: "aa", relative: "bb", full: "cc", size: 30, mimetype: "jpeg" }  
  setup do
    user = insert(:user)

    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
    {:ok, conn: conn, user: user, token: token} 
  end


  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    #attr = put_in @valid_attrs[:user_id], user.id
    #attr_with_file = put_in(attr[:file], @file_attrs)
    file = insert(:asset, @file_attrs)
    post = insert(:post, user_id: user.id, assets: [file])
    # post = Repo.insert! %Post{}
    conn = get conn, post_path(conn, :show, post)
    assert json_response(conn, 200)["data"] == %{"id" => post.id,
      "user_id" => post.user_id,
      "title" => post.title,
      "description" => post.description,
      "email" => user.email, 
      "user_name" => user.name,
      "assets" => [%{
        "id"=> file.id,
        "full"=> file.full,
        "mimetype" => file.mimetype
        }]
      }
  end
  test "shows chosen resource with more files", %{conn: conn, user: user} do
    #attr = put_in @valid_attrs[:user_id], user.id
    #attr_with_file = put_in(attr[:file], @file_attrs)
    file = insert(:asset, @file_attrs)
    file1 = insert(:asset, @file_attrs)
    post = insert(:post, user_id: user.id, assets: [file,file1])
    # post = Repo.insert! %Post{}
    conn = get conn, post_path(conn, :show, post)
    assert length(json_response(conn, 200)["data"]["assets"]) == 2
  end


  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    attr = put_in @valid_attrs[:user_id], user.id
    file  = insert(:asset)
    # attr_with_file = put_in(attr[:file], @file_attrs)
    attr_with_file = put_in(attr[:file_ids], [file.id])
    conn = post conn, post_path(conn, :create), post: attr_with_file
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, attr)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    post = Repo.insert! %Post{user_id: user.id}
    attrs = put_in @valid_attrs[:user_id], user.id
    conn = put conn, post_path(conn, :update, post), post: attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    post = Repo.insert! %Post{user_id: user.id}
    attrs = put_in @invalid_attrs[:user_id], user.id
    conn = put conn, post_path(conn, :update, post), post: attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  test "my posts with entries", %{conn: conn, user: user} do 
    file = insert(:asset, @file_attrs)
    file1 = insert(:asset, @file_attrs)
    insert(:post, user_id: user.id, assets: [file])
    insert(:post, user_id: user.id, assets: [file1])
    conn = get conn, post_path(conn, :my)
    assert response(conn, 200)
    assert length(json_response(conn, 200)["data"]) == 2
  end
  test "my posts without data", %{conn: conn} do 
 
    conn = get conn, post_path(conn, :my)
    assert response(conn, 200)
    assert length(json_response(conn, 200)["data"]) == 0

  end

end
