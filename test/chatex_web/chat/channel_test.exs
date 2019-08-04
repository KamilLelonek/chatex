defmodule ChatexWeb.Chat.ChannelTest do
  use Chatex.TestCase, async: true

  alias ChatexWeb.Chat.{Socket, Channel}
  alias Phoenix.ChannelTest

  @username "username"
  @conversation_id "9"
  @topic "conversation:#{@conversation_id}"

  setup do
    {:ok, socket} = ChannelTest.connect(Socket, %{username: @username})

    {:ok, %{socket: socket}}
  end

  describe "join/3" do
    test "should not join an unknown topic", %{socket: socket} do
      assert_raise RuntimeError,
                   ~r/no channel found for topic "topic" in ChatexWeb.Chat.Socket/,
                   fn ->
                     ChannelTest.join(socket, "topic")
                   end
    end

    test "should not join an invalid topic", %{socket: socket} do
      assert {:error, %{reason: "unauthorized"}} = ChannelTest.join(socket, Channel, "topic")
    end

    test "should join a conversation", %{socket: socket} do
      assert {:ok, %{conversation_id: @conversation_id, username: @username}, _socket} =
               ChannelTest.subscribe_and_join(socket, Channel, @topic)
    end
  end
end
