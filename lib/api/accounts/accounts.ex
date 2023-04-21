defmodule Api.Accounts do
  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Accounts.User

  def list_users() do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user_by(where_clause) do
    Repo.get_by(User, where_clause)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(id, changes) do
    case get_user(id) do
      nil -> {:error, :not_found}
      user -> user |> User.update_change(changes) |> Repo.update()
    end
  end

  def delete_user(id) do
    case get_user(id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end
end
