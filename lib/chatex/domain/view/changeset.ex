defmodule Chatex.Domain.View.Changeset do
  import Ecto.Changeset

  alias Chatex.Domain.View.Schema

  @params_required ~w(reader message_id)a
  @params_optional ~w()a

  def create(params) do
    %Schema{}
    |> cast(params, @params_required ++ @params_optional)
    |> validate_required(@params_required)
    |> unique_constraint(:message_reader,
      name: :views_message_id_reader_index
    )
  end
end
