defmodule Chatex.Factory do
  use ExMachina.Ecto, repo: Chatex.Domain.Repo

  alias Chatex.Domain.Message.Schema, as: Message
  alias Chatex.Domain.Conversation.Schema, as: Conversation
  alias Chatex.Domain.View.Schema, as: View

  def message_factory do
    struct!(
      plain_message_factory(),
      conversation: build(:conversation)
    )
  end

  def plain_message_factory do
    %Message{
      body: "Hello!",
      sender: sequence(:sender, &"username#{&1}")
    }
  end

  def view_factory do
    struct!(
      plain_view_factory(),
      message: build(:message)
    )
  end

  def plain_view_factory do
    %View{
      reader: sequence(:reader, &"username#{&1}")
    }
  end

  def conversation_factory do
    %Conversation{
      members: [],
      creator: sequence(:creator, &"username#{&1}")
    }
  end
end
