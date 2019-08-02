defmodule ChatexWeb.View do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.View,
        root: "lib/chatex_web/templates",
        namespace: ChatexWeb
    end
  end
end
