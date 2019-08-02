import Config

config :chatex, ChatexWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: {:system, "HOST"}, port: 80],
  server: true

config :chatex, Chatex.Domain.Repo, load_from_system_env: true
