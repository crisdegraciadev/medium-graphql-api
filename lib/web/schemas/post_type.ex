defmodule Web.Schemas.PostType do
  alias Api.GenericDataloader
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :post_type do
    field :id, :id
    field :title, :string
    field :content, :string
    field :published, :boolean
    field :user, :user_type, resolve: dataloader(GenericDataloader)
  end

  input_object :post_input_type do
    field :title, non_null(:string)
    field :content, non_null(:string)
  end
end
