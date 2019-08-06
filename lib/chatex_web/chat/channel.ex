defmodule ChatexWeb.Chat.Channel do
  use Phoenix.Channel

  def join(
        "chat",
        _payload,
        socket = %{assigns: %{username: username}}
      ) do
    {:ok, %{username: username}, socket}
  end

  def join(_topic, _params, _socket),
    do: {:error, %{reason: "unauthorized"}}
end
