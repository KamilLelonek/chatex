defmodule ChatexWeb.Chat.Channel do
  use Phoenix.Channel

  def join("conversation:" <> _id, _payload, socket) do
    {:ok, socket}
  end

  def join(_topic, _params, _socket),
    do: {:error, %{reason: "unauthorized"}}
end
