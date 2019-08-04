defmodule Chatex.Factory do
  use ExMachina.Ecto, repo: Chatex.Domain.Repo

  alias Chatex.Domain.Message.Schema, as: Message

  def message_factory do
    %Message{
      conversation_id: sequence(:conversation_id, &to_string(&1)),
      body: "Hello!",
      sender: sequence(:sender, &"username#{&1}")
    }
  end
end
