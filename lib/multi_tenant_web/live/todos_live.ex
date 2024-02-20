defmodule MultiTenantWeb.TodosLive do
  use MultiTenantWeb, :live_view
  alias MultiTenant.Todos

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Todos.subscribe()
    end

    {:ok,
     socket
     |> assign(:page_title, "Todos")
     |> assign(:todos, Todos.list())}
  end

  @impl true
  def handle_info({MultiTenant.Todos, _, _}, socket) do
    {:noreply, socket |> assign(todos: Todos.list())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get!(id)
    {:ok, _} = Todos.delete(todo)

    {:noreply, socket |> assign(todos: Enum.filter(socket.assigns.todos, &(&1.id != todo.id)))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Todos
      <:actions>
        <.link patch={~p"/todos/new"}>
          <.button>New todo</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="todos" rows={@todos}>
      <:col :let={todo} label="Name">
        <%= todo.name %>
      </:col>
      <:col :let={todo} label="Done">
        <%= todo.done %>
      </:col>
      <:action :let={todo}>
        <.link patch={~p"/todos/#{todo}/edit"} id={"edit-#{todo.id}"}>
          <.icon name="hero-pencil" />
        </.link>
      </:action>
      <:action :let={todo}>
        <.link
          phx-click={JS.push("delete", value: %{id: todo.id}) |> hide("##{todo.id}")}
          data-confirm="Are you sure?"
          id={"delete-#{todo.id}"}
        >
          <.icon name="hero-trash" />
        </.link>
      </:action>
    </.table>
    """
  end
end
