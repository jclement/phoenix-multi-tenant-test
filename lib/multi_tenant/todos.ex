defmodule MultiTenant.Todos do
  import Ecto.Query, warn: false
  alias MultiTenant.Repo
  alias MultiTenant.Todos.Todo

  def list() do
    Todo
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get!(id), do: Repo.get!(Todo, id)

  def create(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
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
