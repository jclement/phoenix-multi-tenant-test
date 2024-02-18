defmodule MultiTenantWeb.NotesEditLive do
  alias MultiTenant.Notes
  alias MultiTenant.Notes.Note
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
    |> assign(:page_title, "Edit Note")
    |> assign_note(Notes.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign_note(%Note{})
  end

  defp assign_note(socket, note) do
    # assign the note and its HTML representation to the socket
    socket
    |> assign(:note, note)
    |> assign(:form, to_form(Notes.changeset(note)))
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> Notes.changeset(note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"note" => note_params}, socket),
    do: save(socket, note_params, socket.assigns.live_action)

  defp save(socket, note_params, :new) do
    case Notes.create(note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> assign_note(note)
         |> put_flash(:info, "Note created successfully")
         |> push_navigate(to: ~p"/notes/#{note.id}/edit")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save(socket, note_params, :edit) do
    case Notes.update(socket.assigns.note, note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> assign_note(note)
         |> put_flash(:info, "Note updated successfully")}

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
        <.simple_form for={@form} id="note-form" phx-change="validate" phx-submit="save">
          <.input field={@form[:title]} type="text" label="Title" />
          <.input field={@form[:body]} type="text" label="Body" />

          <:actions>
            <.button phx-disable-with="Saving...">
              Save Note
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end
