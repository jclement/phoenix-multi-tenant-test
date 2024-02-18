defmodule MultiTenant.Repo do
  use Ecto.Repo,
    otp_app: :multi_tenant,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @impl true
  def prepare_query(_operation, query, opts) do
    cond do
      # skip doing tenant things for any operations against the OBAN schema
      opts[:prefix] == "oban" ->
        {query, opts}

      # skip doing tenant things for schema_migrations and operations specifically opting out
      opts[:skip_tenant_id] || opts[:schema_migration] ->
        {query, opts}

      # add the tenant_id to the query
      tenant_id = opts[:tenant_id] ->
        {Ecto.Query.where(query, tenant_id: ^tenant_id), opts}

      # fail compilation if we're missing tenant_id or skip_tenant_id
      true ->
        raise "expected tenant_id or skip_tenant_id to be set"
    end
  end

  @impl true
  def default_options(_operation) do
    # pull tenant_id from the process dictionary, and add as default option on queries
    [tenant_id: get_tenant_id()]
  end

  @tenant_key {__MODULE__, :tenant_id}

  @doc """
  Set the tenant_id on the process dictionary.  Called by plugs.
  """
  def put_tenant_id(tenant_id) do
    Process.put(@tenant_key, tenant_id)
  end

  @doc """
  Get the tenant_id from the process dictionary.
  """
  def get_tenant_id() do
    Process.get(@tenant_key)
  end
end
