defmodule Educator.AAA.Media.Upload do
  @moduledoc "This schema represents an AWS S3 object."

  use Ecto.Schema

  import Ecto.Changeset

  schema "uploads" do
    field :key, :string
    field :mimetype, :string

    timestamps()
  end

  @type t :: %__MODULE__{
          id: integer() | nil,
          key: String.t() | nil,
          mimetype: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @mimetypes ~w[image/png image/jpeg image/svg]

  @spec changeset(t(), :create, map()) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = schema, :create, attrs) do
    schema
    |> cast(attrs, [:key, :mimetype])
    |> validate_required([:key, :mimetype])
    |> validate_inclusion(:mimetype, @mimetypes)
    |> unique_constraint(:key)
  end

  @spec url(t()) :: String.t()
  def url(%{key: key}) do
    alias Educator.AAA.S3

    "#{S3.bucket_url()}/#{key}"
  end
end
