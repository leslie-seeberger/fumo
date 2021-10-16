defmodule Fumo.Authorizer do
  alias Fumo.Accounts.User

  def can_manage?(%User{id: user_id}, %{user_id: resource_user_id}), do: user_id == resource_user_id

  def can_manage?(user, resource) when is_nil(user) or is_nil(resource), do: false
end
