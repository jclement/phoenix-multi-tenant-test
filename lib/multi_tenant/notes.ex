defmodule MultiTenant.Notes do
  import Ecto.Query, warn: false
  alias MultiTenant.Repo
  alias MultiTenant.Notes.Note

  def list() do
    Note
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get!(id), do: Repo.get!(Note, id)

  def create(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Note{} = note) do
    note
    |> Repo.delete()
  end

  def changeset(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
