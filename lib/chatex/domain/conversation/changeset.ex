defmodule Chatex.Domain.Conversation.Changeset do
  import Ecto.Changeset

  alias Chatex.Domain.Conversation.Schema

  @params_required ~w(members creator)a
  @params_optional ~w()a

  def create(params) do
    %Schema{}
    |> cast(params, @params_required ++ @params_optional)
    |> validate_required(@params_required)
    |> unique_constraint(:members_creator,
      name: :conversations_members_creator_index
    )
  end
end
