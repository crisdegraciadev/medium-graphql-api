ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MediumGraphqlApi.Repo, :manual)
# Explicitly get a connection before each test
:ok = Ecto.Adapters.SQL.Sandbox.checkout(MediumGraphqlApi.Repo)

# Setting the shared mode must be done only after checkout
Ecto.Adapters.SQL.Sandbox.mode(MediumGraphqlApi.Repo, {:shared, self()})
