defmodule Educator.AAA.AccountView do
  use Educator.AAA, :view

  def render("educator.json", %{educator: educator}), do: %{educator: educator}
end
