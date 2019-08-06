defmodule Chatex.Domain.Conversation.MutatorTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.Conversation.{Mutator, Schema}
  alias Chatex.Domain.ErrorTranslator

  describe "create/1" do
    test "should create a Conversation with valid params" do
      params = Factory.params_for(:conversation)

      assert {:ok, %Schema{}} = Mutator.create(params)
    end

    test "should not create a Conversation with invalid params" do
      params = Factory.params_for(:conversation, members: 1)

      assert {:error, changeset} = Mutator.create(params)
      assert %{members: ["is invalid"]} == ErrorTranslator.call(changeset)
    end

    test "should not create a Conversation with missing params" do
      params = :conversation |> Factory.params_for() |> Map.drop([:creator])

      assert {:error, changeset} = Mutator.create(params)
      assert %{creator: ["can't be blank"]} == ErrorTranslator.call(changeset)
    end
  end
end
