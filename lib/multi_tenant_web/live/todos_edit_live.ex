defmodule MultiTenantWeb.TodosEditLive do
  alias MultiTenant.Todos
  alias MultiTenant.Todos.Todo
  use MultiTenantWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    # this view is invoked with live_action of either "new" or "edit"
    # call apply_action to handle the live_action
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign_todo(Todos.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign_todo(%Todo{})
  end

  defp assign_todo(socket, todo) do
    # assign the todo and its HTML representation to the socket
    socket
    |> assign(:todo, todo)
    |> assign(:form, to_form(Todos.changeset(todo)))
  end

  @impl true
  def handle_event("validate", %{"todo" => todo_params}, socket) do
    changeset =
      socket.assigns.todo
      |> Todos.changeset(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"todo" => todo_params}, socket),
    do: save(socket, todo_params, socket.assigns.live_action)

  defp save(socket, todo_params, :new) do
    case Todos.create(todo_params) do
      {:ok, todo} ->
        {:noreply,
         socket
         |> assign_todo(todo)
         |> put_flash(:info, "Todo created successfully")
         |> push_navigate(to: ~p"/todos/#{todo.id}/edit")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save(socket, todo_params, :edit) do
    case Todos.update(socket.assigns.todo, todo_params) do
      {:ok, todo} ->
        {:noreply,
         socket
         |> assign_todo(todo)
         |> put_flash(:info, "Todo updated successfully")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @page_title %>
      </.header>

      <div>
        <.simple_form for={@form} id="todo-form" phx-change="validate" phx-submit="save">
          <.input field={@form[:name]} type="text" label="Name" />
          <.input field={@form[:done]} type="checkbox" label="Done?" />

          <:actions>
            <.button phx-disable-with="Saving...">
              Save Todo
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end
