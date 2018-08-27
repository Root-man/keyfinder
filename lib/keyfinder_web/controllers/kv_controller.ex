defmodule KeyfinderWeb.KvController do
  use KeyfinderWeb, :controller
  alias Keyfinder.Keystore

  def lookup(conn, %{"key" => key}) do
    json(conn, %{value: Keystore.lookup(key)})
  end

  def insert(conn, %{"key" => key, "value" => value}) do
    Keystore.put(key, value)
    json(conn, %{status: "OK"})
  end
end
