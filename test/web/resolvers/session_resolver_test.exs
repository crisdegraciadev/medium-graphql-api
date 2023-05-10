defmodule Test.Web.Resolver.Session do
  use ExUnit.Case, async: true
  use Test.Support.Case.ConnCase, async: true
  alias GraphqlBuilder.Query

  describe "login user" do
    test "correct credentials", %{conn: conn} do
      user_input = %{
        email: "test@test.com",
        firstName: "testy",
        lastName: "tytest",
        password: "123456789",
        passwordConfirmation: "123456789"
      }

      register_user = %Query{
        operation: :register_user,
        variables: [
          input: user_input
        ],
        fields: [:id]
      }

      register_user_mutation = GraphqlBuilder.mutation(register_user)
      conn = post(conn, "/api/graphql", %{"query" => register_user_mutation})

      %{email: email, password: password} = user_input

      login = %Query{
        operation: :login_user,
        variables: [input: [email: email, password: password]],
        fields: [:token]
      }

      login_mutation = GraphqlBuilder.mutation(login)
      conn = post(conn, "/api/graphql", %{"query" => login_mutation})

      %{"data" => %{"login_user" => login_user}} = json_response(conn, 200)

      assert Map.has_key?(login_user, "token")
    end

    test "incorrect credentials", %{conn: conn} do
      login = %Query{
        operation: :login_user,
        variables: [input: [email: "test@test.com", password: "111222333444"]],
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
