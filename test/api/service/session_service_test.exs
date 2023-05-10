defmodule Test.Api.Service.Session do
  use ExUnit.Case, async: true
  use Test.Support.Case.DataCase, async: true
  alias Api.Accounts.Guardian
  alias Api.Accounts.Session
  alias Api.Accounts

  @user %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "happy path" do
    test "jwt token is generated and is valid" do
      {:ok, _created_user} = Accounts.create_user(@user)
      {:ok, auth_user} = Session.authenticate(%{email: @user.email, password: @user.password})
      {:ok, jwt_token, _opts} = Guardian.encode_and_sign(auth_user)
      {:ok, _claims} = Guardian.decode_and_verify(jwt_token)
    end
  end

  describe "edge cases" do
    test "invalid credentials raise error" do
      {:ok, _created_user} = Accounts.create_user(@user)
      {:error, :unauthorized} = Session.authenticate(%{email: @user.email, password: "xcvbnm"})
    end
  end
end
