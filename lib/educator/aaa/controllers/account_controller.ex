defmodule Educator.AAA.AccountController do
  use Educator.AAA, :controller

  alias Educator.AAA
  alias Educator.AAA.Accounts
  alias Educator.AAA.S3
  alias Educator.AAA.UploadToken

  alias Plug.Conn

  action_fallback AAA.FallbackController

  plug AAA.Plug.Authenticate when action in [:current, :upload_logo]
  plug :authorize_upload when action in [:upload_logo]

  def register(conn, %{"educator" => educator_params}) do
    with {:ok, %Accounts.Educator{} = educator} <- Accounts.create_educator(educator_params) do
      conn
      |> put_status(:created)
      |> put_session(:educator_id, educator.id)
      |> configure_session(renew: true)
      |> render("educator.json", educator: educator)
    end
  end

  def current(%Conn{assigns: %{educator: educator}} = conn, _params),
    do: render(conn, "educator.json", educator: educator)

  def upload_logo(
        %Conn{assigns: %{educator: educator, upload: upload}} = conn,
        _params
      ) do
    key = S3.Key.generate(upload.mimetype)
    attrs = %{upload | key: key}

    with {:ok, _} <- S3.copy(upload.key, key),
         {:ok, result} <- Accounts.update_educator_logo(educator, attrs),
         %{educator: educator, old_logo: old_logo} = result do
      S3.delete(upload.key)

      if old_logo, do: S3.delete(old_logo.key)

      render(conn, "educator.json", educator: educator)
    else
      _ ->
        S3.delete(key)

        send_resp(conn, :internal_server_error, "")
    end
  end

  defp authorize_upload(
         %Conn{
           assigns: %{educator: %{id: educator_id}},
           params: %{"token" => token}
         } = conn,
         _
       ) do
    case UploadToken.verify(token) do
      {:ok, {^educator_id, %{key: key} = upload}} ->
        if S3.exists?(key) do
          assign(conn, :upload, upload)
        else
          conn
          |> send_resp(:not_found, "")
          |> halt()
        end

      _ ->
        conn
        |> send_resp(:forbidden, "")
        |> halt()
    end
  end

  defp authorize_upload(conn, _) do
    conn
    |> send_resp(:forbidden, "")
    |> halt()
  end
end
