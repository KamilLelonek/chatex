defmodule ChatexWeb.Controller do
  defmacro __using__(_opts) do
    quote do
      use Phoenix.Controller,
        namespace: ChatexWeb
    end
  end
end
