defmodule MediumGraphqlApiWeb.Resolvers.PostResolver do
  alias Ecto.Changeset
  alias MediumGraphqlApi.Accounts.User
  alias MediumGraphqlApi.Blog
  alias MediumGraphqlApiWeb.Utils.ErrorUtils

  def create_post(_parent, %{input: input}, %{context: %{current_user: current_user}}) do
    post_input = Map.merge(input, %{user_id: current_user.id})

    case IO.inspect(Blog.create_post(post_input)) do
      {:ok, post} ->
        {:ok, post}

      {:error, %Changeset{errors: errors}} ->
        ErrorUtils.get_user_friendly_errors(errors)
    end
  end

  # def posts(parent, _input, _resolution) do
  #   parent |> IO.inspect()
  # end

  def posts(%User{id: user_id}, _input, _resolution) do
    {:ok, Blog.list_posts_by_user_id(user_id)}
  end
end
