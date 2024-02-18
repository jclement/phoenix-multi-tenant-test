defmodule MultiTenant.Todos.Todo do
  @moduledoc """
  A schema for a Todo.  These are stored per-tenant.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :name, :string
    field :done, :boolean
    belongs_to :tenant, Tenant

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:name, :done])
    |> validate_required([:name, :done])
  end
end
