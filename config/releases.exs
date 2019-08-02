import Config

config :chatex, Chatex.Domain.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: "POOL_SIZE" |> System.get_env() |> String.to_integer()
