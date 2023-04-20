defmodule Test.SetupDb do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MediumGraphqlApi.Repo)
    :already_shared = Ecto.Adapters.SQL.Sandbox.mode(MediumGraphqlApi.Repo, {:shared, self()})
    :ok
  end
end
