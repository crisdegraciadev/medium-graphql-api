defmodule Test.Support.Case.DataCase do
  use ExUnit.CaseTemplate

  setup do
    setup_sandbox()
    :ok
  end

  def setup_sandbox() do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Api.Repo)
    :already_shared = Ecto.Adapters.SQL.Sandbox.mode(Api.Repo, {:shared, self()})
  end
end
