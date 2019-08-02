defmodule ChatexWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :chatex

  socket "/socket", ChatexWeb.Chat.Socket,
    websocket: true,
    longpoll: false

  plug Plug.Static,
    at: "/",
    from: :chatex,
    gzip: true,
    only: ~w(favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug ChatexWeb.Router
end
