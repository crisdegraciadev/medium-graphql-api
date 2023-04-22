defmodule Test.Web.Resolver.Session do
  use ExUnit.Case, async: true
  use Test.Support.Case.ConnCase, async: true
  alias Test.Support.Fixtures
  alias GraphqlBuilder.Query
  alias Mix.Tasks.Phx.Routes

  setup %{conn: conn} do
    :ok
  end

  describe "login user" do
    test "correct credentials", %{conn: conn} do
      test_user = %{
        email: "test@gmail.com",
        firstName: "testy",
        lastName: "tytest",
        password: "123456789",
        passwordConfirmation: "123456789"
      }

      register_user = %Query{
        operation: :register_user,
        variables: [
          input: test_user
        ],
        fields: [:id]
      }

      register_user_mutation = GraphqlBuilder.mutation(register_user)
      conn = post(conn, "/api/graphql", %{"query" => register_user_mutation})

      %{email: email, password: password} = test_user

      login = %Query{
        operation: :login_user,
        variables: [input: [email: email, password: password]],
        fields: [:token]
      }

      login_mutation = GraphqlBuilder.mutation(login)
      conn = post(conn, "/api/graphql", %{"query" => login_mutation})

      %{"data" => %{"login_user" => %{"token" => token}}} = json_response(conn, 200)
    end

    test "incorrect credentials", %{conn: conn} do
      login = %Query{
        operation: :login_user,
        variables: [input: [email: "cris@gmail", password: "111222333444"]],
        fields: [:token]
      }

      login_mutation = GraphqlBuilder.mutation(login)
      conn = post(conn, "/api/graphql", %{"query" => login_mutation})
      data = json_response(conn, 200)

      %{
        "data" => %{"login_user" => nil},
        "errors" => [%{"message" => error_message}]
      } = data

      assert "unauthorized" == error_message
    end
  end
end
