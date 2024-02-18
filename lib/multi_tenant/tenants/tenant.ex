defmodule MultiTenant.Tenants.Tenant do
  @moduledoc """
  The Tenants context. 
  """
  use Ecto.Schema

  schema "tenants" do
    # display name of the tenant
    field :name, :string

    # list of hostnames that the tenant is associated with
    field :hosts, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end
end
