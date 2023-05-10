defmodule Web.Utils.ErrorUtils do
  # TODO: Replace params
  def get_user_friendly_errors(errors) do
    Enum.map(errors, fn {key, {message, _details}} -> "#{key} #{message}" end)
  end
end
