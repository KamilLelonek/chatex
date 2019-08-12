defmodule Chatex.Domain.View.MutatorTest do
  use Chatex.TestCase, async: true

  alias Chatex.Domain.View.{Mutator, Schema}
  alias Chatex.Domain.ErrorTranslator

  describe "create/1" do
    test "should create a View with valid params" do
      params = Factory.params_with_assocs(:view)

      assert {:ok, %Schema{}} = Mutator.create(params)
    end

    test "should not create a View with invalid params" do
      params = Factory.params_with_assocs(:view, reader: 1)

      assert {:error, changeset} = Mutator.create(params)
      assert %{reader: ["is invalid"]} == ErrorTranslator.call(changeset)
    end

    test "should not create a View with missing params" do
      params = :view |> Factory.params_with_assocs() |> Map.drop([:reader])

      assert {:error, changeset} = Mutator.create(params)
      assert %{reader: ["can't be blank"]} == ErrorTranslator.call(changeset)
    end

    test "should not create the same View twice" do
      params = Factory.params_with_assocs(:view)

      Mutator.create(params)
      assert {:error, changeset} = Mutator.create(params)
      assert %{message_reader: ["has already been taken"]} == ErrorTranslator.call(changeset)
    end
  end
end
