defmodule Chatex.Domain.View.Mutator do
  alias Chatex.Domain.{View.Changeset, Repo}

  def create(params) do
    params
    |> Changeset.create()
    |> Repo.insert()
  end
end
