defmodule Educator.AAA.UploadView do
  use Educator.AAA, :view

  def render("params.json", %{params: params}), do: params
end
