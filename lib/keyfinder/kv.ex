defmodule Keyfinder.Kv do
  @type key :: String.t()
  @type value :: String.t() | nil
  @type t :: [{key(), value()}]

  @spec new() :: t()
  def new(), do: []

  @spec insert(t(), key(), value()) :: t()
  def insert(dict, key, value) do
    if List.keymember?(dict, key, 0) do
      dict
    else
      [{key, value} | dict]
    end
  end

  @spec lookup(t(), key()) :: value()
  def lookup([{key, value} | _tail], key) do
    value
  end
  def lookup([_ | tail], key) do
    lookup(tail, key)
  end
  def lookup([], _key) do
    nil
  end
  # This seems to be slower
  # def lookup(dict, key) do
  #   case List.keyfind(dict, key, 0) do
  #     {^key, value} -> value
  #     nil -> nil
  #   end
  # end
end
