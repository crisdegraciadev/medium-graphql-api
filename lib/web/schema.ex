defmodule Web.Schema do
  alias Api.GenericDataloader
  alias Web.Resolvers
  alias Web.Middleware.Authorize
  use Absinthe.Schema

  import_types(Web.Schemas.UserType)
  import_types(Web.Schemas.SessionType)
  import_types(Web.Schemas.PostType)

  query do
    @desc "Get a single user"
    field :user, :user_type do
      middleware(Authorize, :user)
      arg(:id, non_null(:id))
      resolve(&Resolvers.UserResolver.user/3)
    end

    @desc "Get a list of all users"
    field :users, list_of(:user_type) do
      middleware(Authorize, :user)
      resolve(&Resolvers.UserResolver.users/3)
    end

    @desc "Get a list of Posts"
    field :posts, list_of(:post_type) do
      resolve(&Resolvers.PostResolver.posts/3)
    end
  end

  mutation do
    @desc "Register a new user"
    field :register_user, type: :user_type do
      arg(:input, non_null(:user_input_type))
      resolve(&Resolvers.UserResolver.register_user/3)
    end

    @desc "Login a user and return a JWT Token"
    field :login_user, type: :session_type do
      arg(:input, non_null(:session_input_type))
      resolve(&Resolvers.SessionResolver.login_user/3)
    end

    @desc "Create a blog post"
    field :create_post, type: :post_type do
      middleware(Authorize, :user)
      arg(:input, non_null(:post_input_type))
      resolve(&Resolvers.PostResolver.create_post/3)
    end
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(GenericDataloader, GenericDataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
