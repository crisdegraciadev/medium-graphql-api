defmodule MediumGraphqlApi.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias MediumGraphqlApi.Accounts.User

  schema "posts" do
    field :title, :string
    field :content, :string
    field :published, :boolean, default: false
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :published, :user_id])
    |> validate_required([:title, :content, :published, :user_id])
    |> foreign_key_constraint(:user_id)
  end

  def update_change(post, changes), do: change(post, changes)
end
