defmodule Chatex.Domain.Conversation.LoaderTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.Conversation.Loader

  @member "Kamil"

  describe "all" do
    test "should not load any Conversations" do
      assert [] == Loader.all()
    end

    test "should load all Conversations" do
      c1 = Factory.insert(:conversation)
      c2 = Factory.insert(:conversation)

      assert [^c1, ^c2] = Loader.all()
    end
  end

  describe "member_allowed?/2" do
    test "should not find any member" do
      refute Loader.member_allowed?(UUID.generate(), @member)
    end

    test "should not load a Conversation by the given conversation ID" do
      %{id: id} = Factory.insert(:conversation)

      refute Loader.member_allowed?(id, @member)
    end

    test "should load a Conversation by the given conversation ID" do
      %{id: id} = Factory.insert(:conversation, members: [@member])

      assert Loader.member_allowed?(id, @member)
    end
  end
end
