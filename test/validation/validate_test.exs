defmodule Vr.ValidationTest do
  use Vr.ConnCase
  import Vr.Factory
  alias Vr.User
  setup do
    now = DateTime.utc_now()
    user = insert(:user, inserted_at: now)
    token = User.generate_token(user)
    conn = build_conn() |> put_req_header( "accept", "application/json")
    {:ok, conn: conn, user: user, token: token, now: now} 
  end

  test "validation token", %{conn: conn, user: user,  token: token, now: now} do
    conn = put_req_header(conn, "api-token", "Token: " <> token)
    conn = get conn, session_path(conn, :validate, "user_id": user.id)
    assert json_response(conn, 200) == 
      %{"id" => user.id,
        "name" => user.name,
        "email" => user.email,
        "status" => "registered",
        "inserted_at" => Vr.Convert.native_to_timestamp(now)
      }
  end
  test "invalid token", %{conn: conn, user: user} do
    conn = put_req_header(conn, "api-token", "Token: " <> "invalid token")
    conn = get conn, session_path(conn, :validate, "user_id": user.id)
    assert json_response(conn, 401) 
  end


end
