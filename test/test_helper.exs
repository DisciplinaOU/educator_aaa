{:ok, _pid} = Factory.Sequence.start_link()

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Educator.AAA.Repo, :manual)
