defmodule Educator.AAA.UploadTokenTest do
  use ExUnit.Case, async: true

  alias Educator.AAA.UploadToken

  test "verify/1 successfully decodes token signed by sign/2" do
    payload = {2, 3}

    token = UploadToken.sign(payload)

    assert {:ok, ^payload} = UploadToken.verify(token)
  end

  test "verify/1 returns error when token is nil" do
    assert {:error, :missing} = UploadToken.verify(nil)
  end

  test "verify/1 returns error when token is invalid" do
    assert {:error, :invalid} = UploadToken.verify("invalid token")
  end

  test "verify/1 returns error when token is expired" do
    payload = {2, 3}

    token = UploadToken.sign(payload, signed_at: System.system_time(:seconds) - 60)

    assert {:error, :expired} = UploadToken.verify(token)
  end
end
