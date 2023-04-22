defmodule Test.Support.Fixtures.Auth do
  alias GraphqlBuilder.Query
  use Test.Support.Case.ConnCase, async: true

  @test_user %{
    email: "test@gmail.com",
    firstName: "testy",
    lastName: "tytest",
    password: "123456789",
    passwordConfirmation: "123456789"
  }

  def get_auth_token(conn) do
    conn |> register_user() |> login_user()
  end

  defp register_user(conn) do
    register_user = %Query{
      operation: :register_user,
      variables: [
        input: @test_user
      ],
      fields: [:id]
    }

    register_user_mutation = GraphqlBuilder.mutation(register_user)
    post(conn, "/api/graphql", %{"query" => register_user_mutation})
  end

  defp login_user(conn) do
    %{email: email, password: password} = @test_user

    login = %Query{
      operation: :login_user,
      variables: [input: [email: email, password: password]],
      fields: [:token]
    }

    login_mutation = GraphqlBuilder.mutation(login)
    conn = post(conn, "/api/graphql", %{"query" => login_mutation})

    case json_response(conn, 200) do
      %{"errors" => errors} -> {:error, errors}
      %{"data" => %{"login_user" => %{"token" => token}}} -> {:ok, token}
    end
  end
end
