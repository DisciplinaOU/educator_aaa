defmodule Educator.AAA.Repo do
  use Ecto.Repo, otp_app: :educator_aaa

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    url = System.get_env("DATABASE_URL")

    if opts[:load_from_system_env] && !url do
      raise "expected the DATABASE_URL environment variable to be set"
    end

    {:ok, Keyword.put(opts, :url, url)}
  end
end
