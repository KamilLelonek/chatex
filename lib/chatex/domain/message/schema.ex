defmodule Chatex.Domain.Message.Schema do
  use Chatex.Domain.Schema

  alias Chatex.Domain.Conversation.Schema, as: Conversation
  alias Chatex.Domain.View.Schema, as: View

  schema "messages" do
    field :body, :string
    field :sender, :string

    belongs_to :conversation, Conversation
    has_many :views, View, foreign_key: :id

    timestamps(updated_at: false)
  end
end
