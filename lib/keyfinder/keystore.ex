defmodule Keyfinder.Keystore do
  use GenServer

  alias Keyfinder.Kv
  alias Keyfinder.KvDb

  @mod __MODULE__

  # Interface functions
  @spec put(String.t(), String.t()) :: :ok
  def put(key, value) do
    GenServer.cast(@mod, {:insert, key, value})
  end

  @spec lookup(String.t()) :: String.t()
  def lookup(key) do
    GenServer.call(@mod, {:lookup, key}, 10000)
  end

  # GenServer callbacks
  def start_link(load_from_db) do
    GenServer.start_link(@mod, load_from_db, name: @mod)
  end

  def init(true) do
    GenServer.cast(self(), :create_from_db)
    {:ok, Kv.new()}
  end

  def init(false) do
    {:ok, Kv.new()}
  end

  def handle_cast({:insert, key, value}, state) do
    store_at_db(key, value)
    send_updates(key, value)
    {:noreply, Kv.insert(state, key, value)}
  end

  def handle_cast(:create_from_db, _state) do
    {:noreply, create_state()}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  def handle_call({:lookup, key}, _from, state) do
    {:reply, Kv.lookup(state, key), state}
  end

  def handle_call(_msg, _from, state) do
    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # Internal functions
  defp send_updates(key, value) do
    KeyfinderWeb.Endpoint.send_update(key, value)
  end

  @spec create_state() :: Kv.t()
  defp create_state() do
    Enum.reduce(KvDb.all(), Kv.new(), fn %KvDb{key: key, value: value}, acc ->
      Kv.insert(acc, key, value)
    end)
  end

  @spec store_at_db(String.t(), String.t()) :: :ok
  defp store_at_db(key, value) do
    try do
      KvDb.insert(key, value)
    rescue
      _e in Ecto.ConstraintError -> nil
    end

    :ok
  end
end
