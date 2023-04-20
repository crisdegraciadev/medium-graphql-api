defmodule MediumGraphqlApi.Blog do
  import Ecto.Query, warn: false
  alias MediumGraphqlApi.Repo

  alias MediumGraphqlApi.Blog.Post

  def list_posts() do
    Repo.all(Post)
  end

  def list_posts_by_user_id(user_id) do
    Repo.all(from p in Post, where: p.user_id == ^user_id)
  end

  def get_post(id), do: Repo.get(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end
end
