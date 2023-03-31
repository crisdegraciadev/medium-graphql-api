import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :medium_graphql_api, MediumGraphqlApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "medium_graphql_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :medium_graphql_api, MediumGraphqlApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h09B2mZd2guni/bYf9DH/nmOicXseYArQv8zjxXfF31Motz2DdfJD7H+q/y8dMWl",
  server: false

# In test we don't send emails.
config :medium_graphql_api, MediumGraphqlApi.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
