defmodule Test.MediumGraphqlApi.Service.SessionTest do
  use ExUnit.Case, async: true
  alias MediumGraphqlApi.Accounts.Guardian
  alias MediumGraphqlApi.Accounts.Session
  alias MediumGraphqlApi.Accounts

  @user %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MediumGraphqlApi.Repo)
    # Setting the shared mode must be done only after checkout
    Ecto.Adapters.SQL.Sandbox.mode(MediumGraphqlApi.Repo, {:shared, self()})
  end

  describe "happy path" do
    test "jwt token is generated and is valid" do
      {:ok, createdUser} = Accounts.create_user(@user)
      {:ok, authUser} = Session.authenticate(%{email: @user.email, password: @user.password})
      {:ok, jwt_token, _opts} = Guardian.encode_and_sign(authUser)
      {:ok, _claims} = Guardian.decode_and_verify(jwt_token)
      Accounts.delete_user(createdUser)
    end
  end

  describe "edge cases" do
    test "invalid credentials raise error" do
      {:ok, createdUser} = Accounts.create_user(@user)
      {:error, :unauthorized} = Session.authenticate(%{email: @user.email, password: "xcvbnm"})
      Accounts.delete_user(createdUser)
    end
  end
end
