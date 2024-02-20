defmodule MultiTenantWeb.NoteLiveTest do
  use MultiTenantWeb.ConnCase

  import Phoenix.LiveViewTest
  import MultiTenant.NotesFixtures

  @create_attrs %{title: "some title", body: "some body"}
  @update_attrs %{title: "some updated title", body: "some updated body"}
  @invalid_attrs %{title: nil, body: nil}

  defp create_note(_) do
    note = note_fixture()
    %{note: note}
  end

  describe "Index" do
    setup [:create_note]

    test "lists all notes", %{conn: conn, note: note} do
      {:ok, _index_live, html} = live(conn, ~p"/notes")

      assert html =~ "Listing Notes"
      assert html =~ note.title
    end

    test "new note link", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert index_live |> element("a", "New note") |> render_click() =~ "New note"

      assert_patch(index_live, ~p"/notes/new")
    end

    test "deletes note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert index_live |> element("#delete-#{note.id}") |> render_click()
      refute has_element?(index_live, "#delete-#{note.id}")

      assert_raise Ecto.NoResultsError, fn -> MultiTenant.Notes.get!(note.id) end
    end

    test "edit note link", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert index_live |> element("#edit-#{note.id}") |> render_click()

      assert_patch(index_live, ~p"/notes/#{note.id}/edit")
    end
  end

  describe "New Note" do
    test "save new note", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notes/new")

      assert index_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#note-form", note: @create_attrs)
             |> render_submit()

      {path, flash} =
        assert_redirect(index_live)

      assert [_, id] = Regex.run(~r"/notes/(\d+)/edit", path)
      id = String.to_integer(id)

      assert flash["info"] =~ "Note created successfully"

      assert MultiTenant.Notes.get!(id).title == @create_attrs[:title]
    end
  end

  describe "Update Note" do
    setup [:create_note]

    test "update existing note", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes/#{note.id}/edit")

      assert index_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#note-form", note: @update_attrs)
             |> render_submit()

      assert MultiTenant.Notes.get!(note.id).title == @update_attrs[:title]
    end
  end
end
