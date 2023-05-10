defmodule Test.Support.Fixtures.Accounts do
  alias Api.Accounts
  use Test.Support.Case.ConnCase, async: true

  @user1 %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  @user2 %{
    email: "mar@gmail.com",
    first_name: "Marcos",
    last_name: "Frinch",
    password: "123456789",
    password_confirmation: "123456789"
  }

  def create_test_account() do
    {:ok, user} = Accounts.create_user(@user1)
    user
  end

  def create_test_account_list() do
    [elem(Accounts.create_user(@user1), 1), elem(Accounts.create_user(@user2), 1)]
  end
end
