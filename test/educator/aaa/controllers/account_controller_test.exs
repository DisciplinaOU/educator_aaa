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

    test "responds with 422 when data is invalid", %{conn: conn} do
      educator = attrs_for(:educator, email: nil)
      conn = post(conn, Routes.account_path(conn, :register, %{educator: educator}))

      assert %{} = errors = json_response(conn, :unprocessable_entity)["errors"]
      assert errors != %{}
    end
  end

  @tag session: true
  describe "get current educator" do
    test "renders educator when session is valid", %{conn: conn} do
      educator = insert!(:educator)

      conn =
        conn
        |> put_session(:educator_id, educator.id)
        |> get(Routes.account_path(conn, :current))

      %{email: email, title: title} = educator

      assert %{
               "educator" => %{
                 "id" => id,
                 "email" => ^email,
                 "title" => ^title
               }
             } = json_response(conn, :ok)
    end

    test "responds with 401 when session is invalid or missing", %{conn: conn} do
      conn = get(conn, Routes.account_path(conn, :current))

      assert response(conn, 401) == ""
    end
  end
end
