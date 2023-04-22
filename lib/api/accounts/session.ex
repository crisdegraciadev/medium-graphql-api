defmodule Api.Accounts.Session do
  alias Api.Accounts
  alias Comeonin.Argon2
  alias Api.Accounts.User

  def authenticate(%{email: email, password: password}) do
    case Accounts.get_user_by(email: String.downcase(email)) do
      nil -> {:error, :unauthorized}
      user -> if check_password(user, password), do: {:ok, user}, else: {:error, :unauthorized}
    end
  end

  defp check_password(%User{password_hash: password_hash}, password) do
    Bcrypt.verify_pass(password, password_hash)
  end

  defp check_password(nil, _) do
    Argon2.dummy_checkpw()
  end
end
