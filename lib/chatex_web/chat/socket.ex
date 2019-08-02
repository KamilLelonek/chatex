defmodule ChatexWeb.Chat.Socket do
  use Phoenix.Socket

  channel "conversation:*", ChatexWeb.Chat.Channel

  def connect(_params, socket, _connect_info),
    do: {:ok, socket}

  def id(_socket), do: nil
end
