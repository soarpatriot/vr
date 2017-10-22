defmodule Vr.SessionTest do
  use Vr.ModelCase

  import Vr.Factory

  alias Vr.User
  alias Vr.Session

  #@valid_attrs %{email: "aaa@qq.com", name: "some content", password: "some content"}
  #@invalid_attrs %{}

  test "login with inactive user" do
    insert(:user, name: "adfa", email: "345435@qq.com", password: "2342343aaa")
    params = %{"email" => "345435@qq.com", "password" => "2342343aaa"}
    result = Session.login(params)
    assert {:error, _}  = result
  end

  test "login with active user" do
    user_params = %{email: "23423423@qq.com", name: "aadfasd", password: "23423423423", status: :active}
    changeset = User.registration_changeset(%User{}, user_params) 
    Repo.insert! changeset 
 
    params = %{"email" => "23423423@qq.com", "password" => "23423423423"}
    result = Session.login(params)
    assert {:ok, _}  = result
  end

end
