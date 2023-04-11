defmodule MediumGraphqlApi.Accounts do
  import Ecto.Query, warn: false
  alias MediumGraphqlApi.Repo

  alias MediumGraphqlApi.Accounts.User

  @spec list_users() :: [%User{}]
  def list_users() do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  @spec get_user_by(where_clause :: [key: String.t()]) :: %User{}
  def get_user_by(where_clause) do
    Repo.get_by(User, where_clause)
  end

  @spec create_user(attrs :: map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_user(user :: %User{}, attrs :: map) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @spec delete_user(user :: %User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @spec change_user(user :: %User{}, attrs :: map) :: %Ecto.Changeset{}
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
