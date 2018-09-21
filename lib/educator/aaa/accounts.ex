defmodule Educator.AAA.Accounts do
  @moduledoc "Accounts context."

  alias Educator.AAA.Repo

  @spec create_educator(map()) :: {:ok, __MODULE__.Educator.t()} | {:error, Ecto.Changeset.t()}
  def create_educator(attrs) do
    %__MODULE__.Educator{}
    |> __MODULE__.Educator.changeset(:create, attrs)
    |> Repo.insert()
  end
end
