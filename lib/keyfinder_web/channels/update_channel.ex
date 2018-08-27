defmodule KeyfinderWeb.UpdateChannel do
  use KeyfinderWeb, :channel

  def join("updates:" <> _key, _payload, socket) do
    {:ok, socket}
  end
end
