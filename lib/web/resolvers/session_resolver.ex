defmodule Web.Resolvers.SessionResolver do
  alias Api.Accounts
  alias Api.Accounts.Guardian

  def login_user(_parent, %{input: input}, _resolution) do
    with {:ok, user} <- Accounts.Session.authenticate(input),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    else
      error -> IO.inspect(error)
    end
  end
end
