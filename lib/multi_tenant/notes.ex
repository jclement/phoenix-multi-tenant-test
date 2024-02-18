defmodule MultiTenant.Notes do
  @moduledoc """
  The Notes context.  This object is global (not per tenant)
  """

  import Ecto.Query, warn: false
  alias MultiTenant.Repo
  alias MultiTenant.Notes.Note

  def list() do
    Note
    |> order_by(desc: :inserted_at)
    |> Repo.all(skip_tenant_id: true)
  end

  def get!(id), do: Repo.get!(Note, id, skip_tenant_id: true)

  def create(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert(skip_tenant_id: true)
  end

  def update(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update(skip_tenant_id: true)
  end

  def delete(%Note{} = note) do
    note
    |> Repo.delete(skip_tenant_id: true)
  end

  def changeset(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
