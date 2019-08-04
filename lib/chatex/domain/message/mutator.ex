defmodule Chatex.Domain.Message.Mutator do
  alias Chatex.Domain.{Message.Changeset, Repo}

  def create(params) do
    params
    |> Changeset.create()
    |> Repo.insert()
  end
end
