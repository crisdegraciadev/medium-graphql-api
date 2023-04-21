defmodule MediumGraphqlApi.Accounts.User do
  alias MediumGraphqlApi.Utils.AtomType
  use Ecto.Schema
  import Ecto.Changeset

  @dto_values [:email, :first_name, :last_name, :password, :password_confirmation]

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :role, AtomType, default: :user

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @dto_values)
    |> validate_required(@dto_values)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, fn email -> String.downcase(email) end)
    |> validate_length(:password, min: 8, max: 64)
    |> validate_confirmation(:password)
    |> hash_password()
    |> change(%{role: :user})
  end

  def update_change(user, changes), do: change(user, changes)

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp hash_password(changeset), do: changeset
end
