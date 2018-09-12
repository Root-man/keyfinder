defmodule Keyfinder.Keystore do
  use Agent

  alias Keyfinder.Kv
  alias Keyfinder.KvDb

  @spec lookup(String.t()) :: Kv.value()
  def lookup(key) do
    Agent.get(__MODULE__, fn state -> Kv.lookup(state, key) end)
  end

  @spec insert(String.t(), String.t()) :: :ok
  def insert(key, value) do
    Agent.update(__MODULE__, fn state -> Kv.insert(state, key, value) end)
  end

  # Agent callbacks
  def start_link(false) do
    Agent.start_link(fn -> Kv.new() end, name: __MODULE__)
  end

  def start_link(true) do
    Agent.start_link(fn -> create_state() end, name: __MODULE__)
  end

  defp create_state() do
    Enum.reduce(KvDb.all(), Kv.new(), fn %KvDb{key: key, value: value}, acc ->
      Kv.insert(acc, key, value)
    end)
  end
end
