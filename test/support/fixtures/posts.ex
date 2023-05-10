defmodule Test.Support.Fixtures.Posts do
  alias Api.Blog
  use Test.Support.Case.ConnCase, async: true

  @post1 %{
    title: "My first post",
    content: "The test post content"
  }

  @post2 %{
    title: "My second post",
    content: "The test post content"
  }

  def create_test_post_list(user_id) do
    [
      elem(Blog.create_post(Map.put(@post1, :user_id, user_id)), 1),
      elem(Blog.create_post(Map.put(@post2, :user_id, user_id)), 1)
    ]
  end
end
