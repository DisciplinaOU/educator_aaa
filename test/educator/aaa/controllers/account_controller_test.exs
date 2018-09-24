defmodule Educator.AAA.AccountControllerTest do
  use Educator.AAA.ConnCase, async: true

  describe "register educator" do
    test "renders educator and sets session when data is valid", %{conn: conn} do
      educator = attrs_for(:educator)
      conn = post(conn, Routes.account_path(conn, :register, %{educator: educator}))

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

    test "renders with 422 when data is invalid", %{conn: conn} do
      educator = attrs_for(:educator, email: nil)
      conn = post(conn, Routes.account_path(conn, :register, %{educator: educator}))

      assert %{} = errors = json_response(conn, :unprocessable_entity)["errors"]
      assert errors != %{}
    end
  end
end
