defmodule Educator.AAA.Accounts.Educator do
  @moduledoc "Educator schema"

  use Ecto.Schema

  import Ecto.Changeset
  import Educator.AAA.Password.ChangesetHelpers

  @type t :: %__MODULE__{
          id: integer() | nil,
          title: String.t() | nil,
          email: String.t() | nil,
          password: String.t() | nil,
          password_digest: String.t() | nil,
          inserted_at: String.t() | nil,
          updated_at: String.t() | nil
        }

  schema "educators" do
    field :title, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_digest, :string

    timestamps()
  end

  # Very basic email format check
  @email_regex ~r/^[^@]+@.+\..+$/

  @spec changeset(t(), atom, map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = schema, :create, attrs) do
    schema
    |> cast(attrs, [:title, :email, :password])
    |> validate_required([:title, :email, :password])
    |> update_change(:title, &String.trim/1)
    |> update_change(:email, &String.trim/1)
    |> validate_password(:password, min: 8, not_matches: [:title, :email])
    |> validate_format(:email, @email_regex)
    |> validate_length(:title, min: 2, max: 100)
    |> put_password_digest()
    |> unique_constraint(:title)
    |> unique_constraint(:email)
  end
end

require Protocol

Protocol.derive(Jason.Encoder, Educator.AAA.Accounts.Educator,
  only: ~w[id title email inserted_at updated_at]a
)
