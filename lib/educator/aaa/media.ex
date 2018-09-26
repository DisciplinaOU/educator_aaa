defmodule Educator.AAA.Media do
  @moduledoc "Context for managing media."

  alias __MODULE__.Upload

  alias Educator.AAA.Context
  alias Educator.AAA.Repo

  @spec get_upload(integer()) :: Context.maybe(Upload.t())
  def get_upload(upload_id), do: Repo.get_by(Upload, id: upload_id)

  @spec create_upload(map()) :: Context.result(Upload.t())
  def create_upload(attrs) do
    %Upload{}
    |> Upload.changeset(:create, attrs)
    |> Repo.insert()
  end

  @spec sign_upload(map()) :: Context.result(Upload.t())
  def sign_upload(attrs) do
    %Upload{}
    |> Upload.changeset(:create, attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end
end
