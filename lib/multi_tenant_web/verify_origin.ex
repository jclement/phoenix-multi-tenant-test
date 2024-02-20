defmodule MultiTenantWeb.VerifyOrigin do
  @moduledoc """
  This module is responsible for verifying the origin of the request from the configured tenants
  """
  use Memoize
  require Logger

  def verify_origin?(%URI{} = uri) do
    uri.host in origins()
  end

  defmemop origins(), expires_in: 60 * 1000 do
    MultiTenant.Tenants.list_origins()
  end
end
