defmodule Factory do
  @moduledoc false

  use Factory.Base, repo: Educator.AAA.Repo

  alias Educator.AAA.Password

  @impl Factory.Base
  def build(:educator) do
    %Educator.AAA.Accounts.Educator{
      title: seq("title"),
      email: seq("email", &"user#{&1}@example.com"),
      password: "password"
    }
  end

  @impl Factory.Base
  def pre_insert(:educator, %{password: nil} = schema), do: schema

  @impl Factory.Base
  def pre_insert(:educator, %{password: password} = schema),
    do: struct(schema, Password.add_digest(password))
end
