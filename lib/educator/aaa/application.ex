defmodule Educator.AAA.Application do
  @moduledoc "Educator AAA Service"

  use Application

  alias Educator.AAA

  def start(_type, _args) do
    import Supervisor.Spec

    load_env()

    children = [
      supervisor(Educator.AAA.Repo, []),
      supervisor(Educator.AAA.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: AAA.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    AAA.Endpoint.config_change(changed, removed)

    :ok
  end

  if Mix.env() == :prod do
    defp load_env, do: [nil, nil]
  else
    defp load_env, do: Envy.auto_load()
  end
end
