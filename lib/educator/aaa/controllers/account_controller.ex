defmodule Educator.AAA.AccountController do
  use Educator.AAA, :controller

  alias Educator.AAA
  alias Educator.AAA.Accounts

  action_fallback Educator.AAA.FallbackController

  plug AAA.Plug.Authenticate when action in [:current]

  def register(conn, %{"educator" => educator_params}) do
    with {:ok, %Accounts.Educator{} = educator} <- Accounts.create_educator(educator_params) do
      conn
      |> put_status(:created)
      |> put_session(:educator_id, educator.id)
      |> configure_session(renew: true)
      |> render("educator.json", educator: educator)
    end
  end

  def current(%Plug.Conn{assigns: %{educator: educator}} = conn, _params),
    do: render(conn, "educator.json", educator: educator)
end
