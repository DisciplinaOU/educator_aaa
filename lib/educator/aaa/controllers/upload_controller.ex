defmodule Educator.AAA.UploadController do
  use Educator.AAA, :controller

  alias Educator.AAA
  alias Educator.AAA.Media
  alias Educator.AAA.S3
  alias Educator.AAA.UploadToken

  alias Plug.Conn

  action_fallback AAA.FallbackController

  plug AAA.Plug.Authenticate when action in [:sign]

  def sign(%Conn{assigns: %{educator: educator}} = conn, %{"mimetype" => mimetype}) do
    key = S3.Key.generate(mimetype, tmp: true)
    attrs = %{key: key, mimetype: mimetype}

    with {:ok, upload} <- Media.sign_upload(attrs) do
      token = UploadToken.sign({educator.id, attrs})

      params =
        upload
        |> S3.authenticated_upload_params()
        |> Map.put(:token, token)

      render(conn, "params.json", params: params)
    end
  end
end
