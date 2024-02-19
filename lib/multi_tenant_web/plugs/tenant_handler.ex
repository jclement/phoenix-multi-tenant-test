defmodule MultiTenantWeb.Plugs.TenantHandler do
  @moduledoc """
  The tenant handler plug, responsible for setting the tenant for the request
  """

  use MultiTenantWeb, :verified_routes
  use MultiTenantWeb, :controller

  import Plug.Conn

  alias MultiTenant.Tenants

  def fetch_tenant(conn, _opts) do
    conn

    case Tenants.get_tenant_by_hostname(conn.host) do
      {:ok, tenant} ->
        # add tenant ID to process dictionary to be used by DB operations
        MultiTenant.Repo.put_tenant_id(tenant.id)

        # add tenant to the session / assigns
        conn
        |> assign(:tenant, tenant)
        |> put_session(:tenant_id, tenant.id)

      {:error, _} ->
        # bail on unknown tenant
        conn
        |> put_status(404)
        |> put_view(MultiTenantWeb.ErrorHTML)
        |> render("unknown_tenant.html")
        |> halt()
    end
  end

  def on_mount(:default, _map, %{"tenant_id" => tenant_id}, socket) do
    # copy the tenant_id from the session to the socket for live views
    {:cont,
     socket
     |> Phoenix.Component.assign_new(:tenant, fn ->
       MultiTenant.Repo.put_tenant_id(tenant_id)
       Tenants.get_tenant!(tenant_id)
     end)}
  end
end
