defmodule Educator.AAA.Accounts do
  @moduledoc "Accounts context."

  import Ecto.Query

  alias Ecto.Multi

  alias Educator.AAA.Context
  alias Educator.AAA.Media
  alias Educator.AAA.Repo

  @spec get_educator(integer) :: Context.maybe(__MODULE__.Educator.t())
  def get_educator(educator_id) do
    __MODULE__.Educator
    |> preload(:logo)
    |> Repo.get(educator_id)
  end

  @spec get_educator_by_email(String.t()) :: Context.maybe(__MODULE__.Educator.t())
  def get_educator_by_email(email) when is_binary(email),
    do: Repo.get_by(__MODULE__.Educator, email: email)

  @spec create_educator(map()) :: Context.result(__MODULE__.Educator.t())
  def create_educator(attrs) do
    %__MODULE__.Educator{}
    |> __MODULE__.Educator.changeset(:create, attrs)
    |> Repo.insert()
  end

  @spec authenticate_educator(String.t(), String.t()) :: Context.result(__MODULE__.Educator.t())
  def authenticate_educator(email, password) when is_binary(email) and is_binary(password) do
    email
    |> get_educator_by_email()
    |> __MODULE__.Educator.authenticate(password)
  end

  @spec update_educator_logo(__MODULE__.Educator.t(), map()) ::
          {:ok, map()} | {:error, Multi.name(), any(), %{optional(Multi.name()) => any()}}
  def update_educator_logo(educator, attrs) do
    Multi.new()
    |> Multi.run(:old_logo, fn _ -> {:ok, educator.logo} end)
    |> Multi.run(:upload, fn _ -> Media.create_upload(attrs) end)
    |> Multi.run(:educator, &do_update_educator_logo(educator, &1.upload))
    |> Repo.transaction()
  end

  @spec do_update_educator_logo(__MODULE__.Educator.t(), Media.Upload.t()) ::
          Context.result(__MODULE__.Educator.t())
  defp do_update_educator_logo(educator, %Media.Upload{} = upload) do
    educator
    |> __MODULE__.Educator.changeset(:logo, upload)
    |> Repo.update()
  end
end
