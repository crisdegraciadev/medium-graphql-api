defmodule Test.MediumGraphqlApi.Session do
  use ExUnit.Case, async: true
  alias MediumGraphqlApi.Accounts.Guardian
  alias MediumGraphqlApi.Accounts.Session
  alias MediumGraphqlApi.Accounts
  use Test.SetupDb, async: true

  @user %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "happy path" do
    test "jwt token is generated and is valid" do
      {:ok, _createdUser} = Accounts.create_user(@user)
      {:ok, authUser} = Session.authenticate(%{email: @user.email, password: @user.password})
      {:ok, jwt_token, _opts} = Guardian.encode_and_sign(authUser)
      {:ok, _claims} = Guardian.decode_and_verify(jwt_token)
    end
  end

  describe "edge cases" do
    test "invalid credentials raise error" do
      {:ok, _createdUser} = Accounts.create_user(@user)
      {:error, :unauthorized} = Session.authenticate(%{email: @user.email, password: "xcvbnm"})
    end
  end
end
