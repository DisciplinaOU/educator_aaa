defmodule Educator.AAA.SessionController do
  use Educator.AAA, :controller

  alias Educator.AAA.Accounts

  action_fallback Educator.AAA.FallbackController

  def create(conn, %{"educator" => %{"email" => email, "password" => password}}) do
    with {:ok, %Accounts.Educator{} = educator} <- Accounts.authenticate_educator(email, password) do
      conn
      |> put_status(:created)
      |> put_session(:educator_id, educator.id)
      |> configure_session(renew: true)
      |> render(Educator.AAA.AccountView, "educator.json", educator: educator)
    end
  end
end
