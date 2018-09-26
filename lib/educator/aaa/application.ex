defmodule Educator.AAA.Application do
  @moduledoc "Educator AAA Service"

  use Application

  alias Educator.AAA

  def start(_type, _args) do
    children = [
      AAA.Repo,
      AAA.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Educator.AAA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AAA.Endpoint.config_change(changed, removed)

    :ok
  end
end
