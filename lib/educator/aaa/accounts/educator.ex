defmodule Educator.AAA.Accounts.Educator do
  @moduledoc "Educator schema"

  use Ecto.Schema

  @type t :: %__MODULE__{
          id: integer() | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          password: String.t() | nil,
          password_digest: String.t() | nil,
          inserted_at: String.t() | nil,
          updated_at: String.t() | nil
        }

  schema "educators" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_digest, :string

    timestamps()
  end
end
