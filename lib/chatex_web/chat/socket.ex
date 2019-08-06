defmodule ChatexWeb.Chat.Socket do
  use Phoenix.Socket

  channel "chat", ChatexWeb.Chat.Channel
  channel "conversation:*", ChatexWeb.Chat.Conversation.Channel

  def connect(%{"username" => username}, socket, _connect_info),
    do: {:ok, assign(socket, :username, username)}

  def connect(_params, _socket, _connect_info), do: :error

  def id(%{assigns: %{username: username}})
      when is_binary(username) and
             byte_size(username) > 0,
      do: "user:#{username}"

  def id(_), do: nil
end
