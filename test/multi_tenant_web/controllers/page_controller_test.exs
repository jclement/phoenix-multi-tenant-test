defmodule MultiTenantWeb.PageControllerTest do
  use MultiTenantWeb.ConnCase, async: true

  test "GET / without Tenant", %{conn: conn} do
    conn = %Plug.Conn{conn | host: nil}
    conn = get(conn, ~p"/")
    assert html_response(conn, 404) =~ "Host not found"
  end

  test "GET / bogus Tenant", %{conn: conn} do
    conn = %Plug.Conn{conn | host: "badexample.com"}
    conn = get(conn, ~p"/")
    assert html_response(conn, 404) =~ "Host not found"
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "<b>#{conn.assigns.tenant.name}</b>"
  end
end
