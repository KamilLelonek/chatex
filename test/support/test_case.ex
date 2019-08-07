defmodule Chatex.TestCase do
  use ExUnit.CaseTemplate

  alias Chatex.Domain.Repo
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use Phoenix.ConnTest
      use Phoenix.ChannelTest

      alias ChatexWeb.Router.Helpers, as: Routes
      alias Chatex.Factory
      alias Ecto.UUID

      @endpoint ChatexWeb.Endpoint

      import Chatex.TestCase
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def read_fixture(entity, name, format \\ :strings) do
    "test/support/fixtures/#{entity}/#{name}.json"
    |> File.read!()
    |> Jason.decode!(keys: format)
  end
end
