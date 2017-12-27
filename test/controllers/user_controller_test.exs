defmodule Vr.UserControllerTest do
  use Vr.ConnCase
  require Ecto
  import Vr.Factory
  import Mock

  alias Vr.User
  @valid_attrs %{email: "soarpatriot@126.com", name: "some content", password: "some content"}
  @file_attrs  %{ filename: "aa", parent: "asff",
    murl: "http://yun.com", relative: "bb", full: "cc", size: 30, mimetype: "jpeg" }  
 
  @invalid_attrs %{aa: "bb"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get build_conn(), user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    now = DateTime.utc_now()
    user = Repo.insert! %User{inserted_at: now, avatar_url: "http://qqq.com"}
    conn = get build_conn(), user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "name" => user.name,
      "email" => user.email,
      "status" => "registered",
      "avatar_url" => user.avatar_url, 
      "inserted_at" => Vr.Convert.native_to_timestamp(now)
    }

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
    conn = post build_conn(), user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid" do
    user = Repo.insert! %User{}
    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
 
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    m = %{name: @valid_attrs[:name], email: @valid_attrs[:email]}
    assert Repo.get_by(User, m)
  end

  test "does not update chosen resource and renders errors when data is invalid" do
    user = Repo.insert! %User{}
    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
 
    conn = put conn, user_path(build_conn(), :update, user), user: @invalid_attrs
    assert json_response(conn, 200)
    # assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete build_conn(), user_path(conn, :delete, user)
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
    conn = get build_conn(), user_path(conn, :activation), code: code
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 0
  end

  test "forgot password" do 
    # IO.puts "111"
    user_params = %{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    changeset = User.registration_changeset(%User{}, user_params) 

    user = Repo.insert! changeset 
    # IO.inspect user
    conn = get build_conn(), user_path(build_conn(), :forgot), email: user.email
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 0
  end
  test "change password" do 
    new_password = "333333"
    user_params = %{email: "23423423@qq.com", name: "aadfasd", password: "23423423423"}
    changeset = User.registration_changeset(%User{}, user_params) 

    user = Repo.insert! changeset 
    conn = patch build_conn(), user_path(build_conn(), :pwd), email: user.email, password: new_password
    assert response(conn, 200)


    id = json_response(conn,200)["data"]["id"]
    u = Repo.get(User, id)
    assert u.crypted_password !== user.crypted_password
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
    User.gen_verify(user.id)
    conn = get build_conn(), user_path(conn, :activation), code: "invalid"
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 1
 
  end
   
  test "invalid reactive, email not exist" do 
    conn = post build_conn(), user_path(build_conn(), :reactivation), email: "noexist@qq.com"
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 1
  end

  test "invalid reactive, status already active" do 
    user = insert(:user, email: "85624529@qq.com", status: :active)
    conn = post build_conn(), user_path(build_conn(), :reactivation), email: user.email
    assert response(conn, 200)
    assert json_response(conn, 200)["code"] == 2
  end
  test "reactive success" do 
    user = insert(:user, email: "85624529@qq.com")
    #Vr.Mailer.deliver_later
    with_mock Vr.Mailer, [deliver_later: fn(_user) -> "<html></html>" end] do 
      conn = post build_conn(), user_path(build_conn(), :reactivation), email: user.email
      assert response(conn, 200)
      assert json_response(conn, 200)["code"] == 0
    end
  end

  test "user's posts"  do 
    user = insert(:user)
    file = insert(:asset, @file_attrs)
    insert(:post, user_id: user.id, asset: file)
    # insert(:post, user_id: user.id, assets: [file1])
    conn = get build_conn(), user_path(build_conn(), :posts, user)
    assert response(conn, 200)
    assert length(json_response(conn, 200)["posts"]) == 1
 
  end

  test "qiniu token gen", %{conn: conn} do 
    user = insert(:user)

    token = User.generate_token(user)
    conn = conn |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
 
    conn = post conn, user_path(conn, :qtoken)
    assert String.length(json_response(conn, 200)["token"]) > 10
  end
  test "get user me" do 
    now = DateTime.utc_now()
    user = insert(:user, inserted_at: now)

    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
                        |> put_req_header( "api-token", "Token: " <> token)
 
    conn = get conn, user_path(build_conn(), :me)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "name" => user.name,
      "email" => user.email,
      "status" => "registered",
      "avatar_url" => nil, 
      "inserted_at" => Vr.Convert.native_to_timestamp(now)
    }
  end

end
