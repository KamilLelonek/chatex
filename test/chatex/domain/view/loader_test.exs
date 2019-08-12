defmodule Chatex.Domain.View.LoaderTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.View.Loader

  describe "all" do
    test "should not load any Views" do
      assert [] == Loader.all()
    end

    test "should load all Views" do
      %{id: id1, message_id: message_id1} = Factory.insert(:view)
      %{id: id2, message_id: message_id2} = Factory.insert(:view)

      assert [
               %{id: ^id1, message_id: ^message_id1},
               %{id: ^id2, message_id: ^message_id2}
             ] = Loader.all()
    end
  end

  describe "by_message_id/1" do
    test "should not load any View" do
      assert [] == Loader.by_message_id(UUID.generate())
    end

    test "should not load a not-existing View" do
      Factory.insert(:view)

      assert [] == Loader.by_message_id(UUID.generate())
    end

    test "should load a View by the given message ID" do
      %{message_id: id, reader: reader} = Factory.insert(:view)

      assert [%{reader: ^reader}] = Loader.by_message_id(id)
    end

    test "should load all Views by the given message ID" do
      %{id: message_id} = Factory.insert(:message)
      v1 = Factory.insert(:plain_view, message_id: message_id)
      v2 = Factory.insert(:plain_view, message_id: message_id)

      assert [^v1, ^v2] = Loader.by_message_id(message_id)
    end
  end
end
