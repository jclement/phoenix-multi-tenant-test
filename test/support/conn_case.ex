defmodule MultiTenantWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use MultiTenantWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint MultiTenantWeb.Endpoint

      use MultiTenantWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MultiTenantWeb.ConnCase
    end
  end

  setup tags do
    MultiTenant.DataCase.setup_sandbox(tags)

    conn = Phoenix.ConnTest.build_conn()

    # always bootstrap with a host header for tenant 1
    {t1, _t2} = MultiTenant.TenantsFixtures.tenants_fixture()
    conn = %Plug.Conn{conn | host: hd(t1.hosts)}

    # initialize Repo with tenant 1 so that, by default, setup
    # steps have an assigned tenant.
    MultiTenant.Repo.put_tenant_id(t1.id)

    {:ok, conn: conn}
  end
end
