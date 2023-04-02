defmodule MediumGraphqlApi.Accounts.Session do
  alias Comeonin.Argon2
  alias MediumGraphqlApi.Repo
  alias MediumGraphqlApi.Accounts.User

  def authenticate(%{email: email, password: password}) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> {:error, "Incorrect credentials"}
    end
  end

  defp check_password(%User{password_hash: password_hash}, password) do
    Bcrypt.verify_pass(password, password_hash)
  end

  defp check_password(nil, _) do
    Argon2.dummy_checkpw()
  end
end
