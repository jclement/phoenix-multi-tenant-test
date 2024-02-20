defmodule MultiTenantWeb.TodoLiveTest do
  use MultiTenantWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import MultiTenant.TodosFixtures

  @create_attrs %{name: "some name", done: false}
  @update_attrs %{name: "some updated name", done: true}
  @invalid_attrs %{name: nil, done: false}

  defp create_todo(_) do
    todo = todo_fixture()
    %{todo: todo}
  end

  defp poke_connection(%{conn: conn}) do
    # this is a workaround to kick off the tenant handler plug so that
    # the tenant is set for the create_todo call to work.
    get(conn, "/")
    :ok
  end

  describe "Index" do
    setup [:poke_connection, :create_todo]

    test "lists todos", %{conn: conn, todo: todo} do
      {:ok, _index_live, html} = live(conn, ~p"/todos")

      assert html =~ "Listing Todos"
      assert html =~ todo.name
    end

    test "new todo link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("a", "New todo") |> render_click() =~ "New todo"

      assert_patch(index_live, ~p"/todos/new")
    end

    test "deletes todo in listing", %{conn: conn, todo: todo} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("#delete-#{todo.id}") |> render_click()
      refute has_element?(index_live, "#delete-#{todo.id}")

      assert_raise Ecto.NoResultsError, fn -> MultiTenant.Todos.get!(todo.id) end
    end

    test "edit todo link", %{conn: conn, todo: todo} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("#edit-#{todo.id}") |> render_click()

      assert_patch(index_live, ~p"/todos/#{todo.id}/edit")
    end
  end

  describe "New Todo" do
    test "save new todo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/todos/new")

      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#todo-form", todo: @create_attrs)
             |> render_submit()

      {path, flash} =
        assert_redirect(index_live)

      assert [_, id] = Regex.run(~r"/todos/(\d+)/edit", path)
      id = String.to_integer(id)

      assert flash["info"] =~ "Todo created successfully"

      assert MultiTenant.Todos.get!(id).name == @create_attrs[:name]
    end
  end

  describe "Update Todo" do
    setup [:poke_connection, :create_todo]

    test "update existing todo", %{conn: conn, todo: todo} do
      {:ok, index_live, _html} = live(conn, ~p"/todos/#{todo.id}/edit")

      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#todo-form", todo: @update_attrs)
             |> render_submit()

      assert MultiTenant.Todos.get!(todo.id).name == @update_attrs[:name]
    end
  end
end
