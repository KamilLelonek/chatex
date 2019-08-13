defmodule Chatex.Domain.View.Schema do
  use Chatex.Domain.Schema

  alias Chatex.Domain.Message.Schema, as: Message

  schema "views" do
    field :reader, :string

    belongs_to :message, Message

    timestamps(updated_at: false)
  end
end
