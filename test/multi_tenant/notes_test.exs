defmodule MultiTenant.NotesTest do
  use MultiTenant.DataCase

  alias MultiTenant.Notes
  alias MultiTenant.Notes.Note

  describe "notes" do
    import MultiTenant.NotesFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list/0 returns all notes" do
      note = note_fixture()
      assert Notes.list() == [note]
    end

    test "get!/1 returns the note with given id" do
      note = note_fixture()
      assert Notes.get!(note.id) == note
    end

    test "create/1 with valid data creates a note" do
      valid_attrs = %{
        title: "some title",
        body: "some body"
      }

      assert {:ok, %Note{} = note} = Notes.create(valid_attrs)
      assert note.title == "some title"
      assert note.body == "some body"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the note" do
      note = note_fixture()

      update_attrs = %{
        title: "some updated title",
        body: "some updated body"
      }

      assert {:ok, %Note{} = note} = Notes.update(note, update_attrs)
      assert note.title == "some updated title"
      assert note.body == "some updated body"
    end

    test "update/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update(note, @invalid_attrs)
      assert note == Notes.get!(note.id)
    end

    test "delete/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Notes.delete(note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get!(note.id) end
    end

    test "changeset/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Notes.changeset(note)
    end
  end
end
