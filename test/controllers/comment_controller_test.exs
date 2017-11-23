defmodule Vr.CommentControllerTest do
  use Vr.ConnCase

  import Vr.Factory

  alias Vr.Comment
  alias Vr.User
  @valid_attrs %{content: "some content", post_id: 42, user_id: 42}
  @invalid_attrs %{}

  setup do
    user = insert(:user)

    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
    {:ok, conn: conn, user: user, token: token} 
  end



  test "lists all entries on index", %{conn: conn} do
    conn = get conn, comment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    user_id = user.id
    comment = Repo.insert! %Comment{user_id: user_id}
    conn = get conn, comment_path(conn, :show, comment)
    assert json_response(conn, 200)["data"] == %{"id" => comment.id,
      "user_id" => comment.user_id,
      "post_id" => comment.post_id,
      "content" => comment.content}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, comment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user} do
    attrs = %{@valid_attrs | user_id: user.id}
    conn = post conn, comment_path(conn, :create), comment: attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Comment, attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, comment_path(conn, :create), comment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = put conn, comment_path(conn, :update, comment), comment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Comment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = put conn, comment_path(conn, :update, comment), comment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    comment = Repo.insert! %Comment{}
    conn = delete conn, comment_path(conn, :delete, comment)
    assert response(conn, 204)
    refute Repo.get(Comment, comment.id)
  end
end
