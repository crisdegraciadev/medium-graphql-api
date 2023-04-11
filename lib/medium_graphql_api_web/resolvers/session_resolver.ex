defmodule MediumGraphqlApiWeb.Resolvers.SessionResolver do
  alias MediumGraphqlApi.Accounts
  alias MediumGraphqlApi.Accounts.Guardian

  def login_user(_parent, %{input: input}, _resolution) do
    IO.puts("resolver")

    with {:ok, user} <- Accounts.Session.authenticate(input),
         {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
  end
end
