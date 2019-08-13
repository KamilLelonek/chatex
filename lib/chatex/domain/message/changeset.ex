defmodule Chatex.Domain.Message.Changeset do
  import Ecto.Changeset

  alias Chatex.Domain.Message.Schema

  @params_required ~w(conversation_id body sender)a
  @params_optional ~w()a

  def create(params) do
    %Schema{}
    |> cast(params, @params_required ++ @params_optional)
    |> validate_required(@params_required)
    |> foreign_key_constraint(:conversation_id)
  end
end
