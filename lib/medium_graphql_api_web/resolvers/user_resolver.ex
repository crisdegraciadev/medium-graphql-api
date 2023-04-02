defmodule MediumGraphqlApiWeb.Resolvers.UserResolver do
  alias Ecto.Changeset
  alias MediumGraphqlApi.Accounts

  def users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  def register_user(_parent, %{input: input}, _resolution) do
    case IO.inspect(Accounts.create_user(input)) do
      {:ok, user} -> {:ok, user}
      {:error, %Changeset{errors: errors}} -> {:error, get_user_friendly_errors(errors)}
    end
  end

  defp get_user_friendly_errors(errors) do
    Enum.map(errors, fn {key, {message, _database_details}} -> "#{key} #{message}" end)
  end
end
