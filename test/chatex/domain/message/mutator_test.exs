defmodule Chatex.Domain.Message.MutatorTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.Message.{Mutator, Schema}
  alias Chatex.Domain.ErrorTranslator

  describe "create/1" do
    test "should create a Message with valid params" do
      params = Factory.params_with_assocs(:message)

      assert {:ok, %Schema{}} = Mutator.create(params)
    end

    test "should not create a Message without a Conversation" do
      params = Factory.params_for(:message)

      assert {:error, changeset} = Mutator.create(params)
      assert %{conversation_id: ["can't be blank"]} == ErrorTranslator.call(changeset)
    end

    test "should not create a Message with invalid params" do
      params = Factory.params_for(:message, conversation_id: 1)

      assert {:error, changeset} = Mutator.create(params)
      assert %{conversation_id: ["is invalid"]} == ErrorTranslator.call(changeset)
    end

    test "should not create a Message with missing params" do
      params = :message |> Factory.params_with_assocs() |> Map.drop([:sender])

      assert {:error, changeset} = Mutator.create(params)
      assert %{sender: ["can't be blank"]} == ErrorTranslator.call(changeset)
    end
  end
end
