defmodule ChatexWeb.Chat.SocketTest do
  use Chatex.TestCase, async: true

  alias ChatexWeb.Chat.Socket
  alias Phoenix.ChannelTest

  @username "kamil"

  describe "connect/2" do
    test "should assign a Socket ID with the given username" do
      assert {:ok,
              %Phoenix.Socket{id: "conversation:#{@username}", assigns: %{username: @username}}} =
               ChannelTest.connect(Socket, %{username: @username})
    end

    test "should not assign a Socket ID with a blank username" do
      assert {:ok, %Phoenix.Socket{id: nil, assigns: %{username: ""}}} =
               ChannelTest.connect(Socket, %{username: ""})
    end

    test "should not assign a Socket ID with an empty username" do
      assert {:ok, %Phoenix.Socket{id: nil, assigns: %{username: nil}}} =
               ChannelTest.connect(Socket, %{username: nil})
    end

    test "should not assign any Socket ID without given username but return an error" do
      assert :error = ChannelTest.connect(Socket, %{})
    end
  end
end
