defmodule Test.Web.Resolver.User do
  use ExUnit.Case, async: true
  use Test.Support.Case.ConnCase, async: true
  alias Test.Support.Fixtures.Errors
  alias GraphqlBuilder.Query

  describe "register user" do
    test "register a user with valid input", %{conn: conn} do
      user_input = %{
        email: "test@test.com",
        first_name: "testy",
        last_name: "tytest",
        password: "123456789",
        password_confirmation: "123456789"
      }

      register_user = %Query{
        operation: :register_user,
        variables: [
          input: user_input
        ],
        fields: [:id, :email, :first_name, :last_name]
      }

      register_user_mutation = GraphqlBuilder.mutation(register_user)
      conn = post(conn, "/api/graphql", %{"query" => register_user_mutation})

      %{"data" => %{"register_user" => register_user}} = json_response(conn, 200)

      assert Map.has_key?(register_user, "id")
      assert Map.get(register_user, "email") == Map.get(user_input, :email)
      assert Map.get(register_user, "first_name") == Map.get(user_input, :first_name)
      assert Map.get(register_user, "last_name") == Map.get(user_input, :last_name)
    end

    test "invalid user_input to register", %{conn: conn} do
      invalid_user_input = %{
        email: "test.test.com",
        first_name: "testy",
        last_name: "tytest",
        password: "1234567",
        password_confirmation: "123456"
      }

      register_user = %Query{
        operation: :register_user,
        variables: [
          input: invalid_user_input
        ],
        fields: [:id, :email, :first_name, :last_name]
      }

      register_user_mutation = GraphqlBuilder.mutation(register_user)
      conn = post(conn, "/api/graphql", %{"query" => register_user_mutation})

      %{"errors" => error_list} = json_response(conn, 200)  

      assert length(error_list) == 3
      assert Enum.all?(error_list, fn error -> Errors.check_error_structure(error) end)

      error_messages =
        Enum.map(error_list, fn error -> Map.get(error, "message") end) |> MapSet.new()

      assert MapSet.member?(error_messages, "password_confirmation does not match confirmation")
      assert MapSet.member?(error_messages, "password_confirmation does not match confirmation")
      assert MapSet.member?(error_messages, "email has invalid format")
    end
  end
end
