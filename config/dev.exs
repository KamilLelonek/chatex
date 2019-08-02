import Config

config :chatex, Chatex.Domain.Repo,
  database: "chatex_dev",
  show_sensitive_data_on_connection_error: true

config :chatex, ChatexWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  watchers: []

config :phoenix, :plug_init_mode, :runtime
