defmodule Educator.AAA.Accounts.Educator do
  @moduledoc "Educator schema"

  use Ecto.Schema

  import Ecto.Changeset
  import Educator.AAA.Password.ChangesetHelpers

  schema "educators" do
    field :title, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_digest, :string
    belongs_to :logo, Educator.AAA.Media.Upload, on_replace: :delete

    timestamps()
  end

  @type t :: %__MODULE__{
          id: integer() | nil,
          title: String.t() | nil,
          email: String.t() | nil,
          password: String.t() | nil,
          password_digest: String.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  # Very basic email format check
  @email_regex ~r/^[^@]+@.+\..+$/

  @spec changeset(t(), :create | :logo, any()) :: Ecto.Changeset.t()
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

  def changeset(%__MODULE__{} = schema, :logo, upload) do
    schema
    |> change()
    |> put_assoc(:logo, upload)
    |> unique_constraint(:logo_id)
  end

  @spec authenticate(t() | nil, String.t()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def authenticate(%__MODULE__{} = educator, password) do
    alias Educator.AAA.Password

    if Password.verify(password, educator.password_digest) do
      {:ok, educator}
    else
      {:error, add_error(change(%__MODULE__{}), :password, "is invalid")}
    end
  end

  def authenticate(nil, _password) do
    {:error, add_error(change(%__MODULE__{}), :email, "is not found")}
  end

  defimpl Jason.Encoder do
    def encode(educator, opts) do
      alias Educator.AAA.Media.Upload

      logo_url =
        case educator.logo do
          %Upload{} = upload -> Upload.url(upload)
          _ -> nil
        end

      educator
      |> Map.take(~w[id title email inserted_at updated_at]a)
      |> Map.put(:logo_url, logo_url)
      |> Jason.Encode.map(opts)
    end
  end
end
