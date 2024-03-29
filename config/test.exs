import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :multi_tenant, MultiTenant.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "multi_tenant_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :multi_tenant, MultiTenantWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kItRDxtb3Fj/DYhK36/AXqkgKeToWj4ap801vhHvFHjGN+cpGdOh/fyU3XiBW9qH",
  server: false

# In test we don't send emails.
config :multi_tenant, MultiTenant.Mailer, adapter: Swoosh.Adapters.Test

# don't start scheduler in test environment
config :multi_tenant, :start_oban, false

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
