defmodule Chatex.Domain.Message.Loader do
  alias Chatex.Domain.Repo
  alias Chatex.Domain.Message.Schema, as: Message

  import Ecto.Query, only: [from: 2]

  def all,
    do: Repo.all(Message)

  def by_conversation_id(conversation_id) do
    Repo.all(
      from Message,
        where: [conversation_id: ^conversation_id]
    )
  end
end
