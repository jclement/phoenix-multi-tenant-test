defmodule MultiTenantWeb.NotesLive do
  use MultiTenantWeb, :live_view
  alias MultiTenant.Notes

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Notes")
     |> assign(:notes, Notes.list())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get!(id)
    {:ok, _} = Notes.delete(note)

    {:noreply, socket |> assign(notes: Enum.filter(socket.assigns.notes, &(&1.id != note.id)))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Notes
      <:actions>
        <.link patch={~p"/notes/new"}>
          <.button>New note</.button>
        </.link>
      </:actions>
    </.header>

    <.table id="notes" rows={@notes}>
      <:col :let={note} label="Title">
        <%= note.title %>
      </:col>
      <:col :let={note} label="Body">
        <%= note.body %>
      </:col>
      <:action :let={note}>
        <.link patch={~p"/notes/#{note}/edit"}>
          <.icon name="hero-pencil" />
        </.link>
      </:action>
      <:action :let={note}>
        <.link
          phx-click={JS.push("delete", value: %{id: note.id}) |> hide("##{note.id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" />
        </.link>
      </:action>
    </.table>
    """
  end
end