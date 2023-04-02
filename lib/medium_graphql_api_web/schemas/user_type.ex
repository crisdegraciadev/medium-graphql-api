defmodule MediumGraphqlApiWeb.Schemas.UserType do
  use Absinthe.Schema.Notation

  object :user_type do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :role, :string
  end

  input_object :user_input_type do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
  end
end
