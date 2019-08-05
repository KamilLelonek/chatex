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

  def handle_in("message:send", payload, socket = %{topic: "conversation:" <> conversation_id}) do
    with payload <- Map.put(payload, "conversation_id", conversation_id),
         {:ok, message} <- Domain.store_message(payload),
         :ok <- broadcast(socket, "message:received", message) do
      {:reply, :ok, socket}
    else
      {:error, response} ->
        {:reply, {:error, response}, socket}
    end
  end

  def handle_info(:after_join, socket = %{topic: "conversation:" <> conversation_id}) do
    Enum.each(
      Domain.messages(conversation_id),
      &push(socket, "message:all", &1)
    )

    {:noreply, socket}
  end
end
