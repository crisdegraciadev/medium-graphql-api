defmodule Test.Web.Resolver.Session do
  alias Mix.Tasks.Phx.Routes
  use Test.Setup.ConnCase, async: true

  @login_mutation """
  query GetUser($id: ID!){
    user(id: $id) {
        id,
        email,
        firstName,
        posts {
            id,
            title
        }
    }
  }
  """

  setup %{conn: conn} do
    :ok
  end

  test "prueba", %{conn: conn} do
    conn =
      post(conn, "/api/graphql", %{
        "mutation" => @login_mutation,
        "variables" => %{id: 1}
      })

    IO.inspect(conn)
    IO.inspect(json_response(conn, 200))
  end
end
