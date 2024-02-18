defmodule MultiTenant.Repo do
  use Ecto.Repo,
    otp_app: :multi_tenant,
    adapter: Ecto.Adapters.Postgres
end
