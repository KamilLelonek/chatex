defmodule Chatex.Domain.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  @table :conversations

  def change do
    create table(@table) do
      add :members, {:array, :string}, null: false, default: []
      add :creator, :string, null: false

      timestamps(updated_at: false)
    end

    create unique_index(@table, [:members, :creator])
  end
end
