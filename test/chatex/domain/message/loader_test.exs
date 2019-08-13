defmodule Chatex.Domain.Message.LoaderTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.Message.Loader

  describe "all" do
    test "should not load any Messages" do
      assert [] == Loader.all()
    end

    test "should load all Messages" do
      %{id: id1, conversation_id: conversation_id1} = Factory.insert(:message)
      %{id: id2, conversation_id: conversation_id2} = Factory.insert(:message)

      assert [
               %{id: ^id1, conversation_id: ^conversation_id1},
               %{id: ^id2, conversation_id: ^conversation_id2}
             ] = Loader.all()
    end
  end

  describe "by_conversation_id/1" do
    test "should not load any Message" do
      assert [] == Loader.by_conversation_id(UUID.generate())
    end

    test "should not load a not-existing Message" do
      Factory.insert(:message)

      assert [] == Loader.by_conversation_id(UUID.generate())
    end

    test "should load a Message by the given conversation ID" do
      %{conversation_id: id, body: body, sender: sender} = Factory.insert(:message)

      assert [%{body: ^body, sender: ^sender, views: []}] = Loader.by_conversation_id(id)
    end

    test "should load all Messages by the given conversation ID" do
      %{id: conversation_id} = Factory.insert(:conversation)
      %{id: id1} = Factory.insert(:plain_message, conversation_id: conversation_id)
      %{id: id2} = Factory.insert(:plain_message, conversation_id: conversation_id)

      assert [%{id: ^id2, views: []}, %{id: ^id1, views: []}] =
               Loader.by_conversation_id(conversation_id)
    end
  end
end
