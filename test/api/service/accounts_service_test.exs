defmodule Test.Api.Service.Accounts do
  use ExUnit.Case, async: true
  use Test.Setup.DataCase, async: true
  alias Test.Api.Accounts
  alias Ecto.Changeset
  alias Api.Accounts

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

  describe "create a user" do
    test "create a user with a correct DTO" do
      {:ok, changeset} = Accounts.create_user(@user1)

      assert is_struct(changeset, Accounts.User)
    end

    test "get error when creating a user with an incorrect DTO" do
      {:error, changeset} = Accounts.create_user(%{})
      %Changeset{errors: error_list} = changeset

      assert is_list(error_list)

      [
        email_error,
        first_name_error,
        last_name_error,
        password_error,
        password_confirmation_error | []
      ] = error_list

      assert {:email, {"can't be blank", [validation: :required]}} == email_error
      assert {:first_name, {"can't be blank", [validation: :required]}} == first_name_error
      assert {:last_name, {"can't be blank", [validation: :required]}} == last_name_error
      assert {:password, {"can't be blank", [validation: :required]}} == password_error

      assert {:password_confirmation, {"can't be blank", [validation: :required]}} ==
               password_confirmation_error
    end
  end

  describe "list users with users in db" do
    setup [:seed_with_users]

    test "get a list of 2 users" do
      user_list = Accounts.list_users()

      assert is_list(user_list)
      assert !Enum.empty?(user_list)
      assert length(user_list) == 2

      assert Enum.all?(user_list, fn changeset ->
               is_struct(changeset, Accounts.User)
             end)
    end
  end

  describe "list users without users in db" do
    test "get an empty list of users" do
      user_list = Accounts.list_users()

      assert is_list(user_list)
      assert user_list == []
    end
  end

  describe "get user condition" do
    setup [:seed_with_users]

    test "user is found", %{user_list: [%Accounts.User{id: user_id} | _rest]} do
      changeset = Accounts.get_user(user_id)

      assert is_struct(changeset, Accounts.User)
    end

    test "user is not found" do
      changeset = Accounts.get_user(9_999_999)
      assert changeset == nil
    end
  end

  describe "update user" do
    setup [:seed_with_users]

    test "existing user updated", %{user_list: [%Accounts.User{id: user_id} | _rest]} do
      {:ok, changeset} = Accounts.update_user(user_id, %{first_name: "Papadopoulus"})

      assert is_struct(changeset, Accounts.User)
      %Accounts.User{first_name: "Papadopoulus"} = changeset
    end

    test "user not found" do
      {:error, :not_found} = Accounts.update_user(9_999_999, %{first_name: "Papadopoulus"})
    end
  end

  describe "delete user" do
    setup [:seed_with_users]

    test "user found and deleted" do
      user_list = Accounts.list_users()

      assert is_list(user_list)
      assert !Enum.empty?(user_list)
      assert length(user_list) == 2

      %Accounts.User{id: user_id} = Enum.at(user_list, 0)
      Accounts.delete_user(user_id)

      user_list_without_deleted_user = Accounts.list_users()

      assert is_list(user_list_without_deleted_user)
      assert !Enum.empty?(user_list_without_deleted_user)
      assert length(user_list_without_deleted_user) == 1
    end

    test "user not found to delete it" do
      user_list = Accounts.list_users()

      assert is_list(user_list)
      assert !Enum.empty?(user_list)
      assert length(user_list) == 2

      Accounts.delete_user(9_999_999)

      user_list_without_deleted_user = Accounts.list_users()

      assert is_list(user_list_without_deleted_user)
      assert !Enum.empty?(user_list_without_deleted_user)
      assert length(user_list_without_deleted_user) == 2
    end
  end

  defp seed_with_users(_context) do
    user_list = [elem(Accounts.create_user(@user1), 1), elem(Accounts.create_user(@user2), 1)]
    [user_list: user_list]
  end
end
