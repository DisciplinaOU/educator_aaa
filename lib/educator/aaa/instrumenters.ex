defmodule Educator.AAA.Instrumenters do
  @moduledoc false

  def setup do
    require Prometheus.Registry

    __MODULE__.Phoenix.setup()
    __MODULE__.Pipeline.setup()
    __MODULE__.Ecto.setup()

    Prometheus.Registry.register_collector(:prometheus_process_collector)
  end
end
