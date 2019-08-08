defmodule ChatexWeb.Chat.ChannelTest do
  use Chatex.TestCase, async: false

  alias ChatexWeb.Chat.{Socket, Channel}
  alias Phoenix.ChannelTest
  alias Chatex.Domain

  @username "username"
  @topic "chat"

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
      assert {:ok, %{username: @username}, _socket} =
               ChannelTest.subscribe_and_join(socket, Channel, @topic)
    end
  end

  describe "invite to conversation" do
    test "should create a Conversation", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)

      socket
      |> ChannelTest.push(
        "conversation:invite",
        Factory.params_for(:conversation)
      )
      |> assert_reply(:ok, %{})
    end

    test "should store a Conversation after inviting", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)

      conversation = Factory.params_for(:conversation, members: [@username])

      socket
      |> ChannelTest.push("conversation:invite", conversation)
      |> assert_reply(:ok, %{id: id})

      assert Domain.invited?(id, @username)
    end

    test "should push an invitation after inviting", %{socket: socket} do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, @topic)

      conversation = Factory.params_for(:conversation, members: [@username])

      ChannelTest.push(socket, "conversation:invite", conversation)

      assert_push("conversation:invited", %{id: id})

      assert Domain.invited?(id, @username)
    end
  end
end
