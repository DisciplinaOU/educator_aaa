defmodule Educator.AAA.Plug.AuthenticateTest do
  use Educator.AAA.ConnCase, async: true

  alias Educator.AAA.Plug.Authenticate

  @tag session: true
  test "assings educator when session exists", %{conn: conn} do
    educator = insert!(:educator)

    conn =
      conn
      |> put_session(:educator_id, educator.id)
      |> Authenticate.call([])

    assert %{educator: ^educator} = conn.assigns
  end

  @tag session: true
  test "halts processing when session does not exists", %{conn: conn} do
    conn = Authenticate.call(conn, [])

    assert %Plug.Conn{halted: true, status: 401} = conn
    refute get_session(conn, :educator_id)
    refute conn.assigns[:educator]
  end
end
