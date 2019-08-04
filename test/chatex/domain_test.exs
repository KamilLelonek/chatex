defmodule Chatex.DomainTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain

  describe "store_message/1" do
    test "should store and return a Message" do
      payload = Factory.params_for(:message)

      assert {
               :ok,
               %Chatex.Domain.Message.Schema{
                 body: _,
                 conversation_id: _,
                 sender: _,
                 inserted_at: _,
                 updated_at: _
               }
             } = Domain.store_message(payload)
    end

    test "should not store a Message and return an error" do
      payload = Factory.params_for(:message, sender: 1)

      assert {:error, %{sender: ["is invalid"]}} = Domain.store_message(payload)
    end
  end
end
