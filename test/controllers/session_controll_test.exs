defmodule Vr.SessionControllerTest do
  use Vr.ConnCase
  import Vr.Factory
  alias Vr.User
  setup do
    user = insert(:user)
    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
    {:ok, conn: conn, user: user, token: token} 
  end

  test "validation token", %{conn: conn, user: user,  token: token} do
    conn = put_req_header(conn, "api-token", "Token: " <> token)
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 200) == 
      %{"id" => user.id,
        "name" => user.name,
        "email" => user.email,
        "status" => "registered" 
      }
  end
  test "invalida token", %{conn: conn, user: _user} do
    conn = put_req_header(conn, "api-token", "Token: " <> "invalid token")
    conn = get conn, session_path(conn, :validate)
    assert json_response(conn, 401) 
  end


end
