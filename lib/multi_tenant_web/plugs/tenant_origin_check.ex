defmodule MultiTenantWeb.Plugs.TenantOriginCheck do
  @doc false
  def init(options), do: options

  @doc false
  def call(conn, _opts) do
    origin = Plug.Conn.get_req_header(conn, "origin")

    IO.inspect(origin, label: "origin")

    cond do
      Enum.empty?(origin) -> conn
      origin in MultiTenant.Tenants.list_origins() -> conn
      true -> conn |> Plug.Conn.send_resp(403, "Forbidden") |> Plug.Conn.halt()
    end
  end
end
