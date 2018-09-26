defmodule Educator.AAA.S3.Key do
  @moduledoc "Generates S3 object keys."

  @doc """
  Generates an S3 object key for the given `mimetype`.

  ## Options:

  * `:tmp`: if set to `true`, generate key in the `tmp/` prefix (objects inside
    this prefix expire one day after creation). Defaults to `false`.
  """
  @spec generate(String.t(), Keyword.t()) :: String.t()
  def generate(mimetype, opts \\ []) do
    Ecto.UUID.generate()
    |> put_prefix(Keyword.get(opts, :tmp, false))
    |> put_extension(MIME.extensions(mimetype))
  end

  @tmp_prefix "tmp/"

  @spec put_prefix(String.t(), boolean()) :: String.t()
  defp put_prefix(key, tmp?)
  defp put_prefix(key, false), do: key
  defp put_prefix(key, true), do: @tmp_prefix <> key

  @spec put_extension(String.t(), [String.t()]) :: String.t()
  defp put_extension(key, extensions)
  defp put_extension(key, [ext | _]), do: "#{key}.#{ext}"
  defp put_extension(key, []), do: key
end
