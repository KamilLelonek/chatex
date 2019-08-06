defmodule Chatex.Domain.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  @table :conversations

  def change do
    create table(@table) do
      add :members, {:array, :string}, null: false, default: []
      add :creator, :string, null: false

      timestamps()
    end
  end
end
