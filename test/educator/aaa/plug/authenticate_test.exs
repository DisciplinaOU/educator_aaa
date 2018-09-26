defmodule Educator.AAA.Plug.AuthenticateTest do
  use Educator.AAA.ConnCase, async: true

  alias Educator.AAA.Plug.Authenticate

  @tag session: true
  test "assings educator when session exists", %{conn: conn, educator: educator} do
    %{id: educator_id} = educator

    conn = Authenticate.call(conn, [])

    assert %{educator: %{id: ^educator_id}} = conn.assigns
  end

  test "halts processing when session does not exists", %{conn: conn} do
    conn = Authenticate.call(conn, [])

    assert %Plug.Conn{halted: true, status: 401} = conn
    refute get_session(conn, :educator_id)
    refute conn.assigns[:educator]
  end
end
