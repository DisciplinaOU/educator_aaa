defmodule Educator.AAA.StatusControllerTest do
  use Educator.AAA.ConnCase, async: true

  describe "healthcheck/2" do
    test "returns 204 No Content", %{conn: conn} do
      res =
        conn
        |> get(Routes.status_path(conn, :healthcheck))
        |> response(:no_content)

      assert res == ""
    end
  end
end
