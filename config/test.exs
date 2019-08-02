import Config

config :chatex, Chatex.Domain.Repo,
  database: "chatex_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :chatex, ChatexWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
