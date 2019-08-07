defmodule Chatex.Domain.Message.Schema do
  use Chatex.Domain.Schema

  alias Chatex.Domain.Conversation.Schema, as: Conversation

  schema "messages" do
    field :body, :string
    field :sender, :string

    belongs_to :conversation, Conversation

    timestamps()
  end
end
