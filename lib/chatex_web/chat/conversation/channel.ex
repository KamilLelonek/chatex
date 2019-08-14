defmodule ChatexWeb.Chat.Conversation.Channel do
  use Phoenix.Channel

  alias Chatex.Domain

  intercept ["message:seen"]

  # NOTE: it may be a good idea to introduce additional validation
  # i.e. whether a user is authorized to perform a specific action
  # e.g. sending or reading a message, even though it should be
  # already handled by the entire Channel itself.

  def join(
        "conversation:" <> conversation_id,
        _payload,
        socket = %{assigns: %{username: username}}
      ) do
    conversation_id
    |> Domain.invited?(username)
    |> maybe_join(socket, conversation_id, username)
  end

  def join(_topic, _params, _socket),
    do: {:error, %{reason: "unauthorized"}}

  defp maybe_join(false, _socket, _conversation_id, _username),
    do: {:error, %{reason: "unauthorized"}}

  defp maybe_join(true, socket, conversation_id, username) do
    send(self(), :after_join)

    {:ok, %{conversation_id: conversation_id, username: username}, socket}
  end

  def handle_in(
        "message:send",
        %{"body" => body},
        socket = %{topic: "conversation:" <> conversation_id, assigns: %{username: username}}
      ) do
    with payload <- %{"conversation_id" => conversation_id, "sender" => username, "body" => body},
         {:ok, message} <- Domain.store_message(payload),
         :ok <- broadcast(socket, "message:received", message) do
      {:reply, :ok, socket}
    else
      {:error, response} ->
        {:reply, {:error, response}, socket}
    end
  end

  def handle_in("message:read", payload, socket = %{assigns: %{username: username}}) do
    with payload <- Map.put(payload, "reader", username),
         {:ok, message} <- Domain.read_message(payload),
         :ok <- broadcast(socket, "message:seen", message) do
      {:reply, :ok, socket}
    else
      {:error, response} ->
        {:reply, {:error, response}, socket}
    end
  end

  def handle_info(:after_join, socket = %{topic: "conversation:" <> conversation_id}) do
    # NOTE: consider sending all mesages at once or in batches
    Enum.each(
      Domain.messages(conversation_id),
      &push(socket, "message:all", &1)
    )

    {:noreply, socket}
  end

  def handle_out("message:seen", %{message_id: message_id}, socket) do
    push(socket, "message:views", %{views: Domain.views(message_id)})

    {:noreply, socket}
  end
end
