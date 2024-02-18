defmodule MultiTenant.Tenants do
  @moduledoc """
  The Tenants context.
  """

  import Ecto.Query, warn: false
  alias MultiTenant.Repo
  alias MultiTenant.Tenants.Tenant

  @doc """
  Get the tenant by the hostname (from host header)

  example:

      {:ok, tenant} = MultiTenant.Tenants.get_tenant_by_hostname("example.com")
      {:error, :not_found} = MultiTenant.Tenants.get_tenant_by_hostname("badexample.com")
  """
  def get_tenant_by_hostname(host) do
    tenant = Repo.one(from(r in Tenant, where: ^host in r.hosts), skip_tenant_id: true)

    if tenant do
      {:ok, tenant}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Get the tenant by the tenant id
  """
  def get_tenant!(id) do
    Repo.get!(Tenant, id, skip_tenant_id: true)
  end

  @doc """
  Get origins for all tenants
  """
  def list_origins() do
    Tenant
    |> select([t], t.hosts)
    |> Repo.all(skip_tenant_id: true)
    |> Enum.flat_map(& &1)
  end
end
