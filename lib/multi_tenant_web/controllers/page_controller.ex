defmodule MultiTenantWeb.PageController do
  use MultiTenantWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
