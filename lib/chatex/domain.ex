defmodule Chatex.Domain do
  alias Chatex.Domain.Message.Mutator
  alias Chatex.Domain.ErrorTranslator

  def messages(_conversation_id) do
    []
  end

  def store_message(payload) do
    case Mutator.create(payload) do
      {:ok, message} -> {:ok, message}
      {:error, changeset} -> {:error, ErrorTranslator.call(changeset)}
    end
  end
end
