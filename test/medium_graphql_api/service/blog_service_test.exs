defmodule Test.MediumGraphqlApi.Blog do
  use ExUnit.Case, async: true
  use Test.SetupDb, async: true
  alias MediumGraphqlApi.Blog
  alias MediumGraphqlApi.Accounts

  @user %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  @post1 %{
    title: "My first post",
    content: "The test post content"
  }

  @post2 %{
    title: "My second post",
    content: "The test post content"
  }

  setup [:seed_with_user]

  describe "create a valid post" do
    test "create a valid post", %{user: %{id: user_id}} do
      {:ok, changeset} = Blog.create_post(Map.put(@post1, :user_id, user_id))
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
      {:error, changeset} = Blog.create_post(Map.put(@post1, :user_id, 9_999_999))
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
    setup [:seed_with_posts]

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
    setup [:seed_with_posts]

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
    setup [:seed_with_posts]

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
    setup [:seed_with_posts]

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

  defp seed_with_user(_context) do
    {:ok, user} = Accounts.create_user(@user)
    [user: user]
  end

  defp seed_with_posts(%{user: %{id: user_id}}) do
    post_list = [
      elem(Blog.create_post(Map.put(@post1, :user_id, user_id)), 1),
      elem(Blog.create_post(Map.put(@post2, :user_id, user_id)), 1)
    ]

    [post_list: post_list]
  end
end
