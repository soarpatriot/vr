defmodule Vr.AssetControllerTest do
  use Vr.ConnCase

  import Vr.Factory
  alias Vr.Asset
  alias Vr.User
  @valid_attrs %{filename: "some content", 
   full: "some content", 
   murl: "http://www.yun.com",
   parent: "parent",
   parts: ["a.txt", "b.obj"],
   mimetype: "some content", relative: "some content", size: 42, post_id: 12}
  @invalid_attrs %{}

  setup do
    user = insert(:user)

    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
    {:ok, conn: conn, user: user, token: token} 
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, asset_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = get conn, asset_path(conn, :show, asset)
    assert json_response(conn, 200)["data"] == %{"id" => asset.id,
      "filename" => asset.filename,
      "mimetype" => asset.mimetype,
      "relative" => asset.relative,
      "murl" => asset.murl,
      "full" => asset.full,
      "size" => asset.size}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, asset_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    parts = @valid_attrs[:parts]
    IO.puts "parts:"
    IO.inspect parts
    assert Repo.get_by(Vr.Part, %{name: hd(parts)})
    search_by = Map.drop(@valid_attrs, [:parts])
    assert Repo.get_by(Asset, search_by)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, asset_path(conn, :create), asset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = put conn, asset_path(conn, :update, asset), asset: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    search_by = Map.drop(@valid_attrs, [:parts])
    assert Repo.get_by(Asset, search_by)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = put conn, asset_path(conn, :update, asset), asset: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    asset = Repo.insert! %Asset{}
    conn = delete conn, asset_path(conn, :delete, asset)
    assert response(conn, 204)
    refute Repo.get(Asset, asset.id)
  end
end
