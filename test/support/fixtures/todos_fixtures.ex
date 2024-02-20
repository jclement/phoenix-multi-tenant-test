defmodule MultiTenant.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MultiTenant.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        name: "task",
        done: false
      })
      |> MultiTenant.Todos.create()

    todo
  end
end
