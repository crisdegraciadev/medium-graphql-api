defmodule Test.Web.Resolver.Post do
  use ExUnit.Case, async: true
  use Test.Support.Case.ConnCase, async: true
  alias GraphqlBuilder.Query
  alias Test.Support.Fixtures

  setup %{conn: conn} do
    {:ok, token} = Fixtures.Auth.get_auth_token(conn)
    {:ok, conn: conn |> put_req_header("authorization", "Bearer #{token}")}
  end

  describe "post creation" do
    test "create a post with a valid input", %{conn: conn} do
      post_input = %{
        title: "Post title",
        content: "Post content"
      }

      create_post = %Query{
        operation: :create_post,
        variables: [
          input: post_input
        ],
        fields: [:id, :title, :content, user: [:id, :email]]
      }

      create_post_mutation = GraphqlBuilder.mutation(create_post)
      conn = post(conn, "/api/graphql", %{"query" => create_post_mutation})

      %{"data" => %{"create_post" => create_post}} = json_response(conn, 200)

      assert Map.has_key?(create_post, "id")
      assert Map.get(create_post, "title") == Map.get(post_input, :title)
      assert Map.get(create_post, "content") == Map.get(post_input, :content)

      author = Map.get(create_post, "user")
      assert Map.has_key?(author, "id")
      assert Map.has_key?(author, "email")
    end

    test "invalid post_input to create post", %{conn: conn} do
      post_input = %{
        content: "Post content"
      }

      create_post = %Query{
        operation: :create_post,
        variables: [
          input: post_input
        ],
        fields: [:id]
      }

      create_post_mutation = GraphqlBuilder.mutation(create_post)
      conn = post(conn, "/api/graphql", %{"query" => create_post_mutation})

      %{"errors" => _error_list} = json_response(conn, 200)
    end
  end
end
