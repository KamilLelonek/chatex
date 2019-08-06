defmodule Chatex.Domain.Conversation.Schema do
  use Chatex.Domain.Schema

  schema "conversations" do
    field :members, {:array, :string}
    field :creator, :string

    timestamps()
  end
end
