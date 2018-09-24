defmodule Educator.AAA.Plug.Authenticate do
  @moduledoc "Performs authentication via the session."

  @behaviour Plug

  import Plug.Conn

  alias Educator.AAA.Accounts

  @impl Plug
  def init(opts \\ []), do: opts

  @impl Plug
  def call(conn, _opts) do
    with educator_id when is_integer(educator_id) <- get_session(conn, :educator_id),
         %Accounts.Educator{} = educator <- Accounts.get_educator(educator_id) do
      Logger.metadata(educator_id: educator_id)

      conn
      |> configure_session(renew: true)
      |> assign(:educator, educator)
    else
      _ ->
        conn
        |> configure_session(drop: true)
        |> send_resp(:unauthorized, "")
        |> halt()
    end
  end
end
