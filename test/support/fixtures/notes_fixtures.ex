defmodule MultiTenant.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MultiTenant.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        title: "some answer",
        body: "some body"
      })
      |> MultiTenant.Notes.create()

    note
  end
end
