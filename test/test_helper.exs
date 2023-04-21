ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, :manual)
# Explicitly get a connection before each test
:ok = Ecto.Adapters.SQL.Sandbox.checkout(Api.Repo)

# Setting the shared mode must be done only after checkout
Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, {:shared, self()})
