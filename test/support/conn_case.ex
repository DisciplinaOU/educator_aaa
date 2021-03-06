defmodule Educator.AAA.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Educator.AAA.Router.Helpers, as: Routes

      import Factory

      # The default endpoint for testing
      @endpoint Educator.AAA.Endpoint
    end
  end

  setup tags do
    alias Ecto.Adapters.SQL.Sandbox

    :ok = Sandbox.checkout(Educator.AAA.Repo)

    unless tags[:async] do
      Sandbox.mode(Educator.AAA.Repo, {:shared, self()})
    end

    conn = Plug.Test.init_test_session(Phoenix.ConnTest.build_conn(), %{})

    if tags[:session] do
      %{id: id} = educator = Factory.insert!(:educator)

      conn = Plug.Conn.put_session(conn, :educator_id, id)

      {:ok, conn: conn, educator: educator}
    else
      {:ok, conn: conn}
    end
  end
end
