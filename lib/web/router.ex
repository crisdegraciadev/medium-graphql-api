defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Web.Plug.ContextPlug
  end

  scope "/api" do
    pipe_through [:api, :auth]

    forward "/graphql", Absinthe.Plug, schema: Web.Schema
  end

  if Mix.env() == :dev do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Web.Schema
  end
end
