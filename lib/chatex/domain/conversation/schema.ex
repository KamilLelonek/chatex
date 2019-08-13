defmodule Chatex.Domain.Conversation.Schema do
  use Chatex.Domain.Schema

  alias Chatex.Domain.Message.Schema, as: Message

  schema "conversations" do
    field :members, {:array, :string}
    field :creator, :string

    has_many :messages, Message, foreign_key: :id

    timestamps(updated_at: false)
  end
end
