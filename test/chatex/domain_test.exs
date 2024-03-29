defmodule Chatex.DomainTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain

  @member "Kamil"

  describe "store_message/1" do
    test "should store and return a Message" do
      payload = Factory.params_with_assocs(:message)

      assert {
               :ok,
               %Chatex.Domain.Message.Schema{
                 body: _,
                 conversation_id: _,
                 sender: _,
                 inserted_at: _
               }
             } = Domain.store_message(payload)
    end

    test "should not store a Message and return an error" do
      payload = Factory.params_for(:message, sender: 1)

      assert {:error, %{sender: ["is invalid"]}} = Domain.store_message(payload)
    end

    test "should not store a Message for a non-exitent Conversation" do
      payload = Factory.params_for(:message, conversation_id: UUID.generate())

      assert {:error, %{conversation_id: ["does not exist"]}} = Domain.store_message(payload)
    end
  end

  describe "messages/1" do
    test "should load all Messages by conversation ID" do
      %{id: conversation_id} = Factory.insert(:conversation)

      for _ <- 1..2 do
        :plain_message
        |> Factory.params_for(conversation_id: conversation_id)
        |> Domain.store_message()
      end

      [
        %{conversation_id: ^conversation_id},
        %{conversation_id: ^conversation_id}
      ] = Domain.messages(conversation_id)
    end
  end

  describe "start_conversation/1" do
    test "should start a new Conversation" do
      payload = Factory.params_for(:conversation)

      assert {
               :ok,
               %Chatex.Domain.Conversation.Schema{
                 creator: _,
                 id: _,
                 inserted_at: _,
                 members: [],
                 messages: _
               }
             } = Domain.start_conversation(payload)
    end

    test "should not start a new Conversation" do
      payload = Factory.params_for(:conversation, members: nil)

      assert {:error, %{members: ["can't be blank"]}} = Domain.start_conversation(payload)
    end
  end

  describe "invited?/2" do
    test "should verify whether a member was invited" do
      %{id: conversation_id} = Factory.insert(:conversation, members: [@member])

      assert Domain.invited?(conversation_id, @member)
    end

    test "not should verify whether a member was invited when Conversation doesn't exist" do
      refute Domain.invited?(UUID.generate(), @member)
    end

    test "not should verify whether a member was invited when Conversation exists" do
      refute Domain.invited?(UUID.generate(), @member)

      %{id: conversation_id} = Factory.insert(:conversation, members: [@member])

      refute Domain.invited?(conversation_id, "member")
    end
  end

  describe "views/1" do
    test "should load all Views for a particular Message" do
      %{id: message_id} = Factory.insert(:message)

      for _ <- 1..2 do
        :plain_view
        |> Factory.params_for(message_id: message_id)
        |> Domain.read_message()
      end

      [
        %{message_id: ^message_id},
        %{message_id: ^message_id}
      ] = Domain.views(message_id)
    end
  end

  describe "read_message/1" do
    test "should mark Message as read" do
      %{id: message_id} = Factory.insert(:message)
      payload = %{reader: reader} = Factory.params_for(:view, message_id: message_id)

      assert {:ok, %{reader: ^reader}} = Domain.read_message(payload)
    end

    test "should not mark Message as read without the given Message ID" do
      payload = Factory.params_for(:view)

      assert {:error, %{message_id: ["can't be blank"]}} = Domain.read_message(payload)
    end

    test "should not mark a non-exitent Message as read" do
      payload = Factory.params_for(:view, message_id: UUID.generate())

      assert {:error, %{message_id: ["does not exist"]}} = Domain.read_message(payload)
    end
  end
end
