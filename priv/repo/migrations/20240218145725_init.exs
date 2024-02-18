defmodule MultiTenant.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :name, :string, null: false
      add :done, :boolean, null: false, default: false
      timestamps(type: :utc_datetime)
    end

    create table(:notes) do
      add :title, :string, null: false
      add :body, :string
      timestamps(type: :utc_datetime)
    end
  end
end
