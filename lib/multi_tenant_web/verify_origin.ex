defmodule MultiTenantWeb.VerifyOrigin do
  @moduledoc """
  This module is responsible for verifying the origin of the request from the configured tenants
  """
  def verify_origin?(%URI{} = uri) do
    uri.host in MultiTenant.Tenants.list_origins()
  end
end
