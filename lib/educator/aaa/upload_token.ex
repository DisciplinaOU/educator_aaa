defmodule Educator.AAA.UploadToken do
  @moduledoc "Signs and verifies tokens for uploads."

  alias Educator.AAA.Endpoint

  alias Phoenix.Token

  @type payload :: term()

  @salt "upload"
  # Tokens expire after 1 minute
  @max_age 60

  @spec sign(payload, Keyword.t()) :: String.t()
  def sign(payload, opts \\ []),
    do: Token.sign(Endpoint, @salt, payload, Keyword.take(opts, [:signed_at]))

  @spec verify(String.t()) :: {:ok, payload} | {:error, atom}
  def verify(token), do: Token.verify(Endpoint, @salt, token, max_age: @max_age)
end
