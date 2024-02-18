defmodule MultiTenantWeb.Plugs.TenantOriginCheck do
  @doc false
  def init(options), do: options

  if Application.compile_env(:multi_tenant, :validate_origin) do
    @doc false
    def call(conn, _opts) do
      origin = Plug.Conn.get_req_header(conn, "origin") |> IO.inspect(label: "Origin")

      if (origin in MultiTenant.Tenants.list_origins())
         |> IO.inspect(label: "Configured Origins") do
        conn
      else
        conn |> Plug.Conn.send_resp(403, "Forbidden") |> Plug.Conn.halt()
      end
    end
  else
    def call(conn, _opts) do
      conn
    end
  end
end
