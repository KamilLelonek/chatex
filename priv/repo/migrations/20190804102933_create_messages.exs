defmodule Chatex.Domain.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  @table :messages

  def change do
    create table(@table) do
      add :conversation_id, :string, null: false
      add :body, :text, null: false
      add :sender, :string, null: false

      timestamps()
    end

    create index(@table, :conversation_id)
  end
end
