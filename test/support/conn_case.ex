defmodule Test.Setup.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Test.Setup.ConnCase

      alias Web.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint Web.Endpoint
    end
  end

  setup do
    Test.Setup.DataCase.setup_sandbox()
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
