defmodule Chatex.Domain.Repo.Migrations.CreateViews do
  use Ecto.Migration

  @table :views

  def change do
    create table(@table) do
      add :message_id, references(:messages, on_delete: :delete_all), null: false
      add :reader, :string, null: false

      timestamps()
    end

    create unique_index(@table, [:message_id, :reader])
  end
end
