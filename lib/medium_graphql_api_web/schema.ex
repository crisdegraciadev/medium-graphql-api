defmodule MediumGraphqlApiWeb.Schema do
  alias MediumGraphqlApiWeb.Resolvers
  use Absinthe.Schema

  import_types(MediumGraphqlApiWeb.Schemas.UserType)

  query do
    @desc "Get a list of all users"
    field :users, list_of(:user_type) do
      resolve(&Resolvers.UserResolver.users/3)
    end
  end

  mutation do
    @desc "Register a new user"
    field :register_user, type: :user_type do
      arg(:input, non_null(:user_input_type))
      resolve(&Resolvers.UserResolver.register_user/3)
    end
  end
end
