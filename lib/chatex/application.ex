defmodule Chatex.Application do
  use Application

  def start(_type, _args),
    do: Supervisor.start_link(children(), opts())

  defp children do
    [
      Chatex.Domain.Repo,
      ChatexWeb.Endpoint
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Chatex.Supervisor
    ]
  end

  def config_change(changed, _new, removed) do
    ChatexWeb.Endpoint.config_change(changed, removed)

    :ok
  end
end
