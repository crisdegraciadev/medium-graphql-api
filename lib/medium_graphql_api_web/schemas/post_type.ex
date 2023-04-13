defmodule MediumGraphqlApiWeb.Schemas.PostType do
  alias MediumGraphqlApiWeb.Resolvers
  use Absinthe.Schema.Notation

  object :post_type do
    field :id, :id
    field :title, :string
    field :content, :string
    field :published, :boolean
    field :user, :user_type, resolve: &Resolvers.UserResolver.user/3
  end

  input_object :post_input_type do
    field :title, non_null(:string)
    field :content, non_null(:string)
  end
end
