defmodule ChatexWeb.Chat.Conversation.ChannelTest do
  use Chatex.TestCase, async: false

  alias ChatexWeb.Chat.{Socket, Conversation.Channel}
  alias Phoenix.ChannelTest
  alias Chatex.Domain

  @username "username"

  setup do
    {:ok, socket} = ChannelTest.connect(Socket, %{username: @username})
    %{id: conversation_id} = Factory.insert(:conversation, members: [@username])
    topic = "conversation:" <> conversation_id

    {:ok, %{socket: socket, conversation_id: conversation_id, topic: topic}}
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

    test "should not join a Conversation when not invited", %{topic: topic} do
      {:ok, socket} = ChannelTest.connect(Socket, %{username: "Kamil"})

      assert {:error, %{reason: "unauthorized"}} =
               ChannelTest.subscribe_and_join(socket, Channel, topic)
    end

    test "should join a Conversation", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      assert {:ok, %{conversation_id: ^conversation_id, username: @username}, _socket} =
               ChannelTest.subscribe_and_join(socket, Channel, topic)
    end
  end

  describe "send message" do
    test "should push a Message", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)

      socket
      |> ChannelTest.push(
        "message:send",
        Factory.params_for(:plain_message, conversation_id: conversation_id)
      )
      |> assert_reply(:ok, %{})
    end

    test "should store a Message after pushing", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)

      message =
        %{body: body} = Factory.params_for(:plain_message, conversation_id: conversation_id)

      socket
      |> ChannelTest.push("message:send", message)
      |> assert_reply(:ok, %{})

      assert [%{body: ^body, sender: @username}] = Domain.messages(conversation_id)
    end

    test "should broadcast a Message after pushing", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)

      message =
        %{body: body} = Factory.params_for(:plain_message, conversation_id: conversation_id)

      ChannelTest.push(socket, "message:send", message)

      assert_broadcast("message:received", %{body: ^body, sender: @username})
    end

    test "should receive all Messages after joining", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)

      message =
        %{body: body} = Factory.params_for(:plain_message, conversation_id: conversation_id)

      ChannelTest.push(socket, "message:send", message)
      ChannelTest.subscribe_and_join(socket, Channel, topic)

      assert_push("message:all", %{body: ^body, sender: @username})
    end
  end

  describe "read message" do
    test "should mark a Message as seen", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)
      %{id: message_id} = Factory.insert(:plain_message, conversation_id: conversation_id)

      socket
      |> ChannelTest.push("message:read", %{message_id: message_id})
      |> assert_reply(:ok, %{})

      assert [%{reader: @username, message_id: ^message_id}] = Domain.views(message_id)
    end

    test "should broadcast a View", %{
      socket: socket,
      conversation_id: conversation_id,
      topic: topic
    } do
      {:ok, _, socket} = ChannelTest.subscribe_and_join(socket, Channel, topic)
      %{id: message_id} = Factory.insert(:plain_message, conversation_id: conversation_id)

      ChannelTest.push(socket, "message:read", %{message_id: message_id})

      assert_push("message:views", %{views: [%{reader: @username, message_id: ^message_id}]})
    end
  end
end
