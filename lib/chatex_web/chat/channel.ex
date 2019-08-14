defmodule ChatexWeb.Chat.Channel do
  use Phoenix.Channel

  alias Chatex.Domain

  intercept ["conversation:invited"]

  def join(
        "chat",
        _payload,
        socket = %{assigns: %{username: username}}
      ) do
    {:ok, %{username: username}, socket}
  end

  def join(_topic, _params, _socket),
    do: {:error, %{reason: "unauthorized"}}

  def handle_in("conversation:invite", payload, socket = %{assigns: %{username: username}}) do
    with payload <- update_in(payload["members"], &(&1 ++ [username])),
         {:ok, conversation} <- Domain.start_conversation(payload),
         :ok <- broadcast(socket, "conversation:invited", conversation) do
      {:reply, {:ok, conversation}, socket}
    else
      {:error, response} ->
        {:reply, {:error, response}, socket}
    end
  end

  def handle_out(
        "conversation:invited",
        conversation = %{members: members},
        socket = %{assigns: %{username: username}}
      ) do
    if username in members,
      do: push(socket, "conversation:invited", conversation)

    {:noreply, socket}
  end
end
