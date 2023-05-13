defmodule Api.GenericDataloader do
  def data(), do: Dataloader.Ecto.new(Api.Repo, query: &query/2)

  def query(queryable, _params), do: queryable
end
