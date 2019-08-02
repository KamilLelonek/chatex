import Config

config :chatex,
  ecto_repos: [Chatex.Domain.Repo],
  generators: [binary_id: true]

config :chatex, ChatexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jQuADUDDxCN02g+s9CD2Cxp2WDMRgj9HBMW8a9oUb2+laDKhaU2k+M0KvVk7uQ+y",
  render_errors: [view: ChatexWeb.Errors.View, accepts: ~w(json)],
  check_origin: false,
  pubsub: [name: Chatex.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix,
  stacktrace_depth: 40,
  json_library: Jason

config :chatex, Chatex.Domain.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

import_config "#{Mix.env()}.exs"
