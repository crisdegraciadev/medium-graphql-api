defmodule Test.Api.Schema.Account do
  use ExUnit.Case
  alias Api.Accounts.User

  @user %{
    email: "cris@gmail.com",
    first_name: "Cristian",
    last_name: "Potter",
    password: "123456789",
    password_confirmation: "123456789"
  }

  describe "happy path" do
    test "creates a valid changeset" do
      %Ecto.Changeset{valid?: true, changes: changes} = User.changeset(%User{}, @user)

      %{email: email, first_name: first_name, last_name: last_name, password_hash: password_hash} =
        changes

      assert email == @user.email
      assert first_name == @user.first_name
      assert last_name == @user.last_name
      assert Bcrypt.verify_pass(@user.password, password_hash) == true
    end
  end

  describe "edge cases" do
    test "missing fields" do
      %Ecto.Changeset{valid?: false} = User.changeset(%User{}, Map.delete(@user, :email))
      %Ecto.Changeset{valid?: false} = User.changeset(%User{}, Map.delete(@user, :first_name))
      %Ecto.Changeset{valid?: false} = User.changeset(%User{}, Map.delete(@user, :last_name))
      %Ecto.Changeset{valid?: false} = User.changeset(%User{}, Map.delete(@user, :password))
    end

    test "invalid email" do
      %Ecto.Changeset{valid?: false} =
        User.changeset(%User{}, Map.put(@user, :email, "cris.gmail.com"))
    end

    test "downcased email" do
      %Ecto.Changeset{valid?: true, changes: %{email: email}} =
        User.changeset(%User{}, Map.put(@user, :email, "CRIS@gmail.com"))

      assert email == "cris@gmail.com"
    end

    test "invalid password" do
      %Ecto.Changeset{valid?: false} = User.changeset(%User{}, Map.put(@user, :password, "1234"))
    end

    test "invalid password confirmation" do
      %Ecto.Changeset{valid?: false} =
        User.changeset(%User{}, Map.put(@user, :password_confirmation, "987654321"))
    end
  end
end
