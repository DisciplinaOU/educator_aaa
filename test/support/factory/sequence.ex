defmodule Factory.Sequence do
  @moduledoc false

  use Agent

  @type t :: non_neg_integer()

  @spec start_link() :: Agent.on_start()
  def start_link, do: Agent.start_link(fn -> Map.new() end, name: __MODULE__)

  @spec next(String.t()) :: t() | no_return()
  def next(name) do
    Agent.get_and_update(__MODULE__, fn sequences ->
      Map.get_and_update(sequences, name, fn
        nil -> {0, 1}
        val -> {val, val + 1}
      end)
    end)
  end
end
