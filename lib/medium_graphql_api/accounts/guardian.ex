defmodule MediumGraphqlApi.Accounts.Guardian do
  use Guardian, otp_app: :medium_graphql_api
  alias MediumGraphqlApi.Accounts

  def subject_for_token(%Accounts.User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end
end
