defmodule Test.Api.Service.Blog do
  use ExUnit.Case, async: true
  use Test.Support.Case.DataCase, async: true
  alias Test.Support.Fixtures
  alias Api.Blog

  setup do
    [user: Fixtures.Accounts.create_test_account()]
  end

  describe "create a valid post" do
    test "create a valid post", %{user: %{id: user_id}} do
      post = %{
        title: "My first post",
        content: "The test post content"
      }

      {:ok, changeset} = Blog.create_post(Map.put(post, :user_id, user_id))
      assert is_struct(changeset, Blog.Post)
    end

    test "get an error when creating a post with missing information", %{user: %{id: user_id}} do
      {:error, changeset} = Blog.create_post(Map.put(%{}, :user_id, user_id))
      %Ecto.Changeset{errors: error_list} = changeset

      assert is_list(error_list)
      assert length(error_list)

      [title_error, content_error | []] = error_list

      assert {:title, {"can't be blank", [validation: :required]}} == title_error
      assert {:content, {"can't be blank", [validation: :required]}} == content_error
    end

    test "get an error when creating a post with unexisting user" do
      post = %{
        title: "My first post",
        content: "The test post content"
      }

      {:error, changeset} = Blog.create_post(Map.put(post, :user_id, 9_999_999))
      %Ecto.Changeset{errors: error_list} = changeset

      assert is_list(error_list)

      [user_error | []] = error_list
      {error_field, error_info} = user_error

      assert error_field == :user_id
      assert {"does not exist", violated_contraint} = error_info
      assert [constraint: :foreign, constraint_name: "posts_user_id_fkey"] == violated_contraint
    end
  end

  describe "list all posts" do
    setup %{user: %{id: user_id}} do
      [post_list: Fixtures.Posts.create_test_post_list(user_id)]
    end

    test "get a list of 2 posts" do
      post_list = Blog.list_posts()

      assert is_list(post_list)
      assert !Enum.empty?(post_list)
      assert length(post_list) == 2

      assert Enum.all?(post_list, fn changeset ->
               is_struct(changeset, Blog.Post)
             end)
    end
  end

  describe "list no posts" do
    test "get an empty list of posts" do
      post_list = Blog.list_posts()

      assert is_list(post_list)
      assert post_list == []
    end
  end

  describe "find posts by condition" do
    setup %{user: %{id: user_id}} do
      [post_list: Fixtures.Posts.create_test_post_list(user_id)]
    end

    test "post is found", %{post_list: [%Blog.Post{id: post_id} | _rest]} do
      changeset = Blog.get_post(post_id)

      assert is_struct(changeset, Blog.Post)
    end

    test "post is not found" do
      changeset = Blog.get_post(9_999_999)

      assert changeset == nil
    end
  end

  describe "update post" do
    setup %{user: %{id: user_id}} do
      [post_list: Fixtures.Posts.create_test_post_list(user_id)]
    end

    test "existing post updated", %{post_list: [%Blog.Post{id: post_id} | _rest]} do
      {:ok, changeset} = Blog.update_post(post_id, %{title: "New post title"})

      assert is_struct(changeset, Blog.Post)
      %Blog.Post{title: "New post title"} = changeset
    end

    test "user not found" do
      {:error, :not_found} = Blog.update_post(9_999_999, %{title: "New post title"})
    end
  end

  describe "delete post" do
    setup %{user: %{id: user_id}} do
      [post_list: Fixtures.Posts.create_test_post_list(user_id)]
    end

    test "post found and deleted" do
      post_list = Blog.list_posts()

      assert is_list(post_list)
      assert !Enum.empty?(post_list)
      assert length(post_list) == 2

      %Blog.Post{id: post_id} = Enum.at(post_list, 0)
      Blog.delete_post(post_id)

      post_list_without_deleted_post = Blog.list_posts()

      assert is_list(post_list_without_deleted_post)
      assert !Enum.empty?(post_list_without_deleted_post)
      assert length(post_list_without_deleted_post) == 1
    end

    test "user not found to delete it" do
      post_list = Blog.list_posts()

      assert is_list(post_list)
      assert !Enum.empty?(post_list)
      assert length(post_list) == 2

      Blog.delete_post(9_999_999)

      post_list_without_deleted_post = Blog.list_posts()

      assert is_list(post_list_without_deleted_post)
      assert !Enum.empty?(post_list_without_deleted_post)
      assert length(post_list_without_deleted_post) == 2
    end
  end
end
