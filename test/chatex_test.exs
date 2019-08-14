defmodule ChatexTest do
  use Chatex.TestCase, async: false

  alias Phoenix.ChannelTest
  alias ChatexWeb.Chat.Socket
  alias ChatexWeb.Chat.Channel, as: ChatChannel
  alias ChatexWeb.Chat.Conversation.Channel, as: ConversationChannel
  alias Chatex.Domain

  @username1 "Bob"
  @username2 "Alice"

  describe "integration" do
    test "should go through the entire flow" do
      {:ok, socket1} = ChannelTest.connect(Socket, %{username: @username1})
      {:ok, socket2} = ChannelTest.connect(Socket, %{username: @username2})

      {:ok, _, socket1} = ChannelTest.subscribe_and_join(socket1, ChatChannel, "chat")
      {:ok, _, socket2} = ChannelTest.subscribe_and_join(socket2, ChatChannel, "chat")

      conversation = Factory.params_for(:conversation, members: [@username2])

      ChannelTest.push(socket1, "conversation:invite", conversation)

      assert_push("conversation:invited", %{id: id})
      assert Domain.invited?(id, @username1)
      assert Domain.invited?(id, @username2)

      {:ok, _, socket1} =
        ChannelTest.subscribe_and_join(socket1, ConversationChannel, "conversation:#{id}")

      message = Factory.params_for(:plain_message, conversation_id: id)

      ChannelTest.push(socket1, "message:send", message)

      assert_broadcast("message:received", %{body: body, sender: @username1})
      assert [%{conversation_id: ^id, sender: @username1, body: ^body}] = Domain.messages(id)

      {:ok, _, socket2} =
        ChannelTest.subscribe_and_join(socket2, ConversationChannel, "conversation:#{id}")

      {:ok, _, socket2} =
        ChannelTest.subscribe_and_join(socket2, ConversationChannel, "conversation:#{id}")

      assert_push("message:all", %{body: ^body, sender: @username1, id: message_id})

      ChannelTest.push(socket2, "message:read", %{message_id: message_id})

      assert_push("message:views", %{views: [%{reader: @username2, message_id: ^message_id}]})
    end
  end
end
