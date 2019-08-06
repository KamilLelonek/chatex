defmodule Chatex.Domain.Conversation.Mutator do
  alias Chatex.Domain.{Conversation.Changeset, Repo}

  def create(params) do
    params
    |> Changeset.create()
    |> Repo.insert()
  end
end
