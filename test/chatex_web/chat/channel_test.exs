defmodule ChatexWeb.Chat.ChannelTest do
  use Chatex.TestCase, async: false

  alias ChatexWeb.Chat.{Socket, Channel}
  alias Phoenix.ChannelTest
  alias Chatex.Domain

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

  describe "send message" do
    test "should push a Message", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)

      socket
      |> ChannelTest.push("message:send", Factory.params_for(:message))
      |> assert_reply(:ok, %{})
    end

    test "should store a Message after pushing", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)
      message = %{body: body, sender: sender} = Factory.params_for(:message)

      socket
      |> ChannelTest.push("message:send", message)
      |> assert_reply(:ok, %{})

      assert [%{body: ^body, sender: ^sender}] = Domain.messages(@conversation_id)
    end

    test "should broadcast a Message after pushing", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)
      message = %{body: body, sender: sender} = Factory.params_for(:message)

      ChannelTest.push(socket, "message:send", message)

      assert_broadcast("message:received", %{body: ^body, sender: ^sender})
    end

    test "should receive all Messages after joining", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)
      message = %{body: body, sender: sender} = Factory.params_for(:message)

      ChannelTest.push(socket, "message:send", message)
      ChannelTest.subscribe_and_join(socket, Channel, @topic)

      assert_push("message:all", %{body: ^body, sender: ^sender})
    end
  end
end
