defmodule Chatex.Domain.Message.Schema do
  use Chatex.Domain.Schema

  schema "messages" do
    field :conversation_id, :string
    field :body, :string
    field :sender, :string

    timestamps()
  end
end
