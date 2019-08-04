defmodule ChatexWeb.Chat.Channel do
  use Phoenix.Channel

  alias Chatex.Domain

  def join(
        "conversation:" <> conversation_id,
        _payload,
        socket = %{assigns: %{username: username}}
      ) do
    send(self(), :after_join)

    {:ok, %{conversation_id: conversation_id, username: username}, socket}
  end

  def join(_topic, _params, _socket),
    do: {:error, %{reason: "unauthorized"}}

  def handle_info(:after_join, socket = %{topic: "conversation:" <> conversation_id}) do
    Enum.each(
      Domain.messages(conversation_id),
      &push(socket, "message", &1)
    )

    {:noreply, socket}
  end
end
