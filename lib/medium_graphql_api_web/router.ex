defmodule MediumGraphqlApiWeb.Router do
  use MediumGraphqlApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MediumGraphqlApiWeb.Plug.ContextPlug
  end

  scope "/api" do
    pipe_through [:api, :auth]

    forward "/graphql", Absinthe.Plug, schema: MediumGraphqlApiWeb.Schema
  end

  if Mix.env() == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: MediumGraphqlApiWeb.Schema
  end
end
