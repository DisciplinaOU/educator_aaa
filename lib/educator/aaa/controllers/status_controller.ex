defmodule Educator.AAA.StatusController do
  use Educator.AAA, :controller

  def healthcheck(conn, _params), do: send_resp(conn, :no_content, "")
end
