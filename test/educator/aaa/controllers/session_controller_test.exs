defmodule Educator.AAA.SessionControllerTest do
  use Educator.AAA.ConnCase, async: true

  describe "create session" do
    test "renders educator and sets session when credentials are valid", %{conn: conn} do
      educator = insert!(:educator, password: "password")
      params = %{email: educator.email, password: "password"}
      conn = post(conn, Routes.session_path(conn, :create, %{educator: params}))

      %{email: email, title: title} = educator

      assert %{
               "educator" => %{
                 "id" => id,
                 "email" => ^email,
                 "title" => ^title
               }
             } = json_response(conn, :created)

      assert id == get_session(conn, :educator_id)
    end

    test "responds with 422 when credentials are invalid", %{conn: conn} do
      params = %{email: "no@such.email", password: "password"}
      conn = post(conn, Routes.session_path(conn, :create, %{educator: params}))

      assert %{} = errors = json_response(conn, :unprocessable_entity)["errors"]
      assert errors != %{}
    end
  end
end
