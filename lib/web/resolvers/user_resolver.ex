defmodule Web.Resolvers.UserResolver do
  alias Api.Blog.Post
  alias Ecto.Changeset
  alias Api.Accounts
  alias Web.Utils.ErrorUtils

  def user(_parent, %{id: id}, _resolution), do: get_user_by_id(id)

  def user(%Post{user_id: id}, _input, _resolution), do: get_user_by_id(id)

  defp get_user_by_id(id) do
    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, %{input: input}, _resolution) do
    case Accounts.create_user(input) do
      {:ok, user} ->
        {:ok, user}

      {:error, %Changeset{errors: errors}} ->
        {:error, ErrorUtils.get_user_friendly_errors(errors)}
    end
  end
end
