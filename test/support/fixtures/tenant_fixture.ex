defmodule MultiTenant.TenantsFixtures do
  @moduledoc """
  This module defines test helpers for creating tenants
  """

  def tenant1_fixture() do
    MultiTenant.Repo.insert!(%MultiTenant.Tenants.Tenant{
      name: "tenant1",
      hosts: ["host1a", "host1b"]
    })
  end

  def tenant2_fixture() do
    MultiTenant.Repo.insert!(%MultiTenant.Tenants.Tenant{
      name: "tenant2",
      hosts: ["host2"]
    })
  end

  def tenants_fixture do
    {tenant1_fixture(), tenant2_fixture()}
  end
end
