defmodule Educator.AAA.Password do
  @moduledoc """
  Utilities for generating password hashes and verifying passwords.
  """

  alias Comeonin.Argon2, as: Hasher

  @spec add_digest(String.t()) :: %{password: nil, password_digest: String.t()}
  def add_digest(password), do: Hasher.add_hash(password, hash_key: :password_digest)
end
