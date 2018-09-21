defmodule Educator.AAA.Password.ChangesetHelpers do
  @moduledoc "Changeset-related password helpers."

  import Ecto.Changeset

  alias Ecto.Changeset
  alias Educator.AAA.Password

  @spec put_password_digest(Changeset.t()) :: Changeset.t()
  def put_password_digest(%Changeset{valid?: true, changes: %{password: password}} = changeset),
    do: change(changeset, Password.add_digest(password))

  def put_password_digest(changeset), do: changeset

  @default_password_validation_opts [min: 8, not_matches: []]

  # NOTE(smaximov): we can (and probably should) also check the password against a
  # dictionary of common/breached passwords and password's entropy.
  @spec validate_password(Changeset.t(), atom, Keyword.t()) :: Changeset.t()
  def validate_password(changeset, field, opts \\ []) do
    opts = Keyword.merge(@default_password_validation_opts, opts)

    validate_change(changeset, field, {:password, opts}, fn ^field, password ->
      with :ok <- validate_password_length(password, opts),
           :ok <- validate_not_matches(changeset, password, opts) do
        []
      else
        {:error, error} -> [{field, error}]
      end
    end)
  end

  @typep error :: String.t() | {String.t(), Keyword.t()}
  @typep result :: :ok | {:error, error()}

  @spec validate_password_length(String.t(), Keyword.t()) :: result()
  defp validate_password_length(password, opts) do
    len = String.length(password)
    min_length = opts[:min]

    if len >= min_length do
      :ok
    else
      {:error,
       {"should be at least #{min_length} character(s)",
        validation: :password, length: len, min: min_length}}
    end
  end

  @spec validate_not_matches(Changeset.t(), String.t(), Keyword.t()) :: result()
  defp validate_not_matches(changeset, password, opts) do
    fields = opts[:not_matches]
    password = String.downcase(password)

    Enum.reduce_while(fields, :ok, fn field, :ok ->
      {_source, field_value} = fetch_field(changeset, field)

      if String.downcase(field_value) == password do
        {:halt, {:error, {"matches #{field}", validation: :password, matches: field}}}
      else
        {:cont, :ok}
      end
    end)
  end
end
