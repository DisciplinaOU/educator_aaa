defmodule Educator.AAA.UploadControllerTest do
  use Educator.AAA.ConnCase, async: true

  alias Educator.AAA.UploadToken

  describe "sign uploads" do
    test "responds with 401 when session is invalid or expired", %{conn: conn} do
      conn = post(conn, Routes.upload_path(conn, :sign))

      assert response(conn, :unauthorized) == ""
    end

    @tag session: true
    test "responds with 422 when mimetype is invalid", %{conn: conn} do
      conn = post(conn, Routes.upload_path(conn, :sign, %{mimetype: "text/csv"}))

      assert %{
               "errors" => %{
                 "mimetype" => ["is invalid"]
               }
             } = json_response(conn, :unprocessable_entity)
    end

    @tag session: true
    test "responds with 200 and valid token when mimetype is valid", %{
      conn: conn,
      educator: %{id: educator_id}
    } do
      mimetype = "image/png"
      conn = post(conn, Routes.upload_path(conn, :sign, %{mimetype: mimetype}))

      assert %{
               "url" => _url,
               "data" => %{"key" => key},
               "token" => token
             } = json_response(conn, :ok)

      assert {:ok, {^educator_id, %{key: ^key, mimetype: ^mimetype}}} = UploadToken.verify(token)
    end
  end
end
