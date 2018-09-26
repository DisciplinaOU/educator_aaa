defmodule Educator.AAA.Context do
  @moduledoc "Helper types for Ecto contexts."

  @type result(schema_type) :: {:ok, schema_type} | {:error, Ecto.Changeset.t()}
  @type maybe(schema_type) :: schema_type | nil
end
