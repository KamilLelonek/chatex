defmodule Chatex.Domain do
  alias Chatex.Domain.Message.Loader, as: MessageLoader
  alias Chatex.Domain.Message.Mutator, as: MessageMutator
  alias Chatex.Domain.Conversation.Loader, as: ConversationLoader
  alias Chatex.Domain.Conversation.Mutator, as: ConversationMutator
  alias Chatex.Domain.ErrorTranslator

  defdelegate messages(conversation_id),
    to: MessageLoader,
    as: :by_conversation_id

  def store_message(payload) do
    case MessageMutator.create(payload) do
      {:ok, message} -> {:ok, message}
      {:error, changeset} -> {:error, ErrorTranslator.call(changeset)}
    end
  end

  defdelegate invited?(conversation_id, member),
    to: ConversationLoader,
    as: :member_allowed?

  def start_conversation(payload) do
    case ConversationMutator.create(payload) do
      {:ok, message} -> {:ok, message}
      {:error, changeset} -> {:error, ErrorTranslator.call(changeset)}
    end
  end
end
