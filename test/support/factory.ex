defmodule Chatex.Factory do
  use ExMachina.Ecto, repo: Chatex.Domain.Repo

  alias Chatex.Domain.Message.Schema, as: Message
  alias Chatex.Domain.Conversation.Schema, as: Conversation

  def message_factory do
    %Message{
      conversation: build(:conversation),
      body: "Hello!",
      sender: sequence(:sender, &"username#{&1}")
    }
  end

  def conversation_factory do
    %Conversation{
      members: [],
      creator: sequence(:sender, &"username#{&1}")
    }
  end
end
