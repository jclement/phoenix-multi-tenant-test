defmodule MultiTenant.Notes.Note do
  @moduledoc """
  The Notes context.  This object is global (not per tenant)
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :body])
    |> validate_required([:title])
  end
end
