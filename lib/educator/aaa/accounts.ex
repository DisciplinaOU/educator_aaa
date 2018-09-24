defmodule Educator.AAA.Accounts do
  @moduledoc "Accounts context."

  alias Educator.AAA.Repo

  @type result(schema_type) :: {:ok, schema_type} | {:error, Ecto.Changeset.t()}
  @type maybe(schema_type) :: schema_type | nil

  @spec create_educator(map()) :: result(__MODULE__.Educator.t())
  def create_educator(attrs) do
    %__MODULE__.Educator{}
    |> __MODULE__.Educator.changeset(:create, attrs)
    |> Repo.insert()
  end

  @spec get_educator_by_email(String.t()) :: maybe(__MODULE__.Educator.t())
  def get_educator_by_email(email) when is_binary(email),
    do: Repo.get_by(__MODULE__.Educator, email: email)

  @spec authenticate_educator(String.t(), String.t()) :: result(__MODULE__.Educator.t())
  def authenticate_educator(email, password) when is_binary(email) and is_binary(password) do
    email
    |> get_educator_by_email()
    |> __MODULE__.Educator.authenticate(password)
  end
end
