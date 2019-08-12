defmodule Chatex.Domain.View.Loader do
  alias Chatex.Domain.Repo
  alias Chatex.Domain.View.Schema, as: View

  import Ecto.Query, only: [from: 2]

  def all,
    do: Repo.all(View)

  def by_message_id(message_id) do
    Repo.all(
      from View,
        where: [message_id: ^message_id]
    )
  end
end
