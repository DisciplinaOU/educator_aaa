defmodule Educator.AAA.AccountController do
  use Educator.AAA, :controller

  alias Educator.AAA.Accounts

  action_fallback Educator.AAA.FallbackController

  def register(conn, %{"educator" => educator_params}) do
    with {:ok, %Accounts.Educator{} = educator} <- Accounts.create_educator(educator_params) do
      conn
      |> put_status(:created)
      |> put_session(:educator_id, educator.id)
      |> render("educator.json", educator: educator)
    end
  end
end
