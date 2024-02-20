defmodule MultiTenant.TodosTest do
  use MultiTenant.DataCase

  alias MultiTenant.Repo
  alias MultiTenant.Todos
  alias MultiTenant.Todos.Todo

  describe "todos" do
    import MultiTenant.TodosFixtures
    import MultiTenant.TenantsFixtures

    @invalid_attrs %{tenant_id: nil, title: nil, body: nil}

    test "list/0 returns all todos for tenant" do
      {t1, t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()

      assert Todos.list() == [todo]

      Repo.put_tenant_id(t2.id)
      assert Todos.list() == []
    end

    test "list_all/0 returns all todos" do
      {t1, t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()

      Repo.put_tenant_id(t1.id)
      assert Todos.list_all() == [todo]

      Repo.put_tenant_id(t2.id)
      assert Todos.list_all() == [todo]
    end

    test "get!/1 returns the todo with given id" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()

      assert Todos.get!(todo.id) == todo
    end

    test "create/1 with valid data creates a todo" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)

      valid_attrs = %{
        name: "some title",
        done: true
      }

      assert {:ok, %Todo{} = todo} = Todos.create(valid_attrs)
      assert todo.name == "some title"
      assert todo.done == true
      assert todo.tenant_id == t1.id
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create(@invalid_attrs)
    end

    test "create/1 with no tenant fails" do
      {_t1, _t2} = tenants_fixture()

      valid_attrs = %{
        name: "some title",
        done: true
      }

      assert_raise Postgrex.Error, fn -> Todos.create(valid_attrs) end
    end

    test "update/2 with valid data updates the todo" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()

      update_attrs = %{
        name: "some updated title",
        done: false
      }

      assert {:ok, %Todo{} = todo} = Todos.update(todo, update_attrs)
      assert todo.name == "some updated title"
      assert todo.done == false
    end

    test "update/2 with invalid data returns error changeset" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update(todo, %{"name" => nil, "done" => nil})
      assert todo == Todos.get!(todo.id)
    end

    test "delete/1 deletes the todo" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get!(todo.id) end
    end

    test "changeset/1 returns a todo changeset" do
      {t1, _t2} = tenants_fixture()
      Repo.put_tenant_id(t1.id)
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.changeset(todo)
    end
  end
end
