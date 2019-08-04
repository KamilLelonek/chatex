defmodule Chatex.Domain.Message.LoaderTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.Message.Loader

  describe "all" do
    test "should not load any Messages" do
      assert [] == Loader.all()
    end

    test "should load all Messages" do
      m1 = Factory.insert(:message)
      m2 = Factory.insert(:message)

      assert [^m1, ^m2] = Loader.all()
    end
  end

  describe "by_conversation_id/1" do
    test "should not load any Message" do
      refute Loader.by_conversation_id("1")
    end

    test "should not load a not-existing Message" do
      Factory.insert(:message)

      refute Loader.by_conversation_id("007")
    end

    test "should load a Message by the given ID" do
      m = %{conversation_id: id} = Factory.insert(:message)

      assert ^m = Loader.by_conversation_id(id)
    end
  end
end
