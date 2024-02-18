defmodule MultiTenant.Todos do
  @moduledoc """
  The Todos context.
  """
  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias MultiTenant.Repo
  alias MultiTenant.Todos.Todo

  def list() do
    # return todo from the current tenant, relying on the tenant_id set on the process
    Todo
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_all() do
    # return all todos, regardless of tenant
    Todo
    |> order_by(desc: :inserted_at)
    |> Repo.all(skip_tenant_id: true)
  end

  def get!(id), do: Repo.get!(Todo, id)

  def create(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    # Ensure the tenant_id is added to new records
    |> put_change(:tenant_id, MultiTenant.Repo.get_tenant_id())
    |> Repo.insert()
  end

  def update(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Todo{} = todo) do
    todo
    |> Repo.delete()
  end

  def changeset(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end
end
