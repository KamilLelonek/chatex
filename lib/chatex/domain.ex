defmodule Chatex.Domain do
  alias Chatex.Domain.Message.{Mutator, Loader}
  alias Chatex.Domain.ErrorTranslator

  defdelegate messages(onversation_id),
    to: Loader,
    as: :by_conversation_id

  def store_message(payload) do
    case Mutator.create(payload) do
      {:ok, message} -> {:ok, message}
      {:error, changeset} -> {:error, ErrorTranslator.call(changeset)}
    end
  end
end
