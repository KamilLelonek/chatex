defmodule Chatex.Domain.Conversation.Loader do
  alias Chatex.Domain.Repo
  alias Chatex.Domain.Conversation.Schema, as: Conversation

  import Ecto.Query, only: [from: 2]

  def all,
    do: Repo.all(Conversation)

  def member_allowed?(conversation_id, member) do
    Repo.exists?(
      from c in Conversation,
        where:
          c.id == ^conversation_id and
            ^member in c.members
    )
  end
end
