defmodule Test.Api.Schema.Post do
  use ExUnit.Case
  alias Api.Blog.Post

  describe "happy path" do
    test "creates a valid changeset" do
      post = %{
        title: "Post title",
        content: "Post content",
        user_id: 1
      }

      %Ecto.Changeset{valid?: true, changes: changes} = Post.changeset(%Post{}, post)

      %{content: content, title: title, user_id: user_id} = changes

      assert content == post.content
      assert title == post.title
      assert user_id == post.user_id
    end
  end

  describe "edge cases" do
    test "missing fields" do
      post = %{
        title: "Post title",
        content: "Post content",
        user_id: 1
      }

      %Ecto.Changeset{valid?: false} = Post.changeset(%Post{}, Map.delete(post, :title))
      %Ecto.Changeset{valid?: false} = Post.changeset(%Post{}, Map.delete(post, :title))
      %Ecto.Changeset{valid?: false} = Post.changeset(%Post{}, Map.delete(post, :user_id))
    end
  end
end
