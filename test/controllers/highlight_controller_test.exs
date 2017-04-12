defmodule Vr.HighlightControllerTest do
  use Vr.ConnCase

  import Vr.Factory

  alias Vr.Highlight
  @valid_attrs %{post_id: 42}
  @invalid_attrs %{}
  @file_attrs  %{ filename: "aa", relative: "bb", full: "cc", size: 30, mimetype: "jpeg" }  

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, highlight_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    highlight = Repo.insert! %Highlight{}
    conn = get conn, highlight_path(conn, :show, highlight)
    assert json_response(conn, 200)["data"] == %{"id" => highlight.id,
      "post_id" => highlight.post_id}
  end
  test "shows lastest resource", %{conn: conn} do
    user = insert(:user)
    file = insert(:asset, @file_attrs)
    post = insert(:post, user_id: user.id, assets: [file])
    # file = insert(:file, post: post)
    insert(:highlight, post: post)
    conn = get conn, highlight_path(conn, :lastest)
    assert json_response(conn, 200)["data"] == %{"id" => post.id,
      "user_id" => post.user_id,
      "title" => post.title,
      "description" => post.description,
      "email" => user.email, 
      "assets" => [%{
        "id" => file.id,
        "full"=> file.full,
        "mimetype" => file.mimetype
      }],
      "user_name" => user.name

      }
  end


  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, highlight_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, highlight_path(conn, :create), highlight: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Highlight, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, highlight_path(conn, :create), highlight: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    highlight = Repo.insert! %Highlight{}
    conn = put conn, highlight_path(conn, :update, highlight), highlight: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Highlight, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    highlight = Repo.insert! %Highlight{}
    conn = put conn, highlight_path(conn, :update, highlight), highlight: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    highlight = Repo.insert! %Highlight{}
    conn = delete conn, highlight_path(conn, :delete, highlight)
    assert response(conn, 204)
    refute Repo.get(Highlight, highlight.id)
  end
end
