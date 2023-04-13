defmodule MediumGraphqlApiWeb.Utils.ErrorUtils do
  def get_user_friendly_errors(errors) do
    Enum.map(errors, fn {key, {message, _database_details}} -> "#{key} #{message}" end)
  end
end
