defmodule KeyfinderWeb.UpdateChannelTest do
  use KeyfinderWeb.ChannelCase

  alias KeyfinderWeb.UpdateChannel

  setup do
    {:ok, _, socket} =
      socket()
      |> subscribe_and_join(UpdateChannel, "updates:John")

    {:ok, socket: socket}
  end

  test "Check that we receive updates with new value for key subscribed", %{socket: _socket} do
    KeyfinderWeb.Endpoint.send_update("John", "new_val")
    assert_broadcast("new_value", %{key: "John", value: "new_val"}, 500)
  end
end
