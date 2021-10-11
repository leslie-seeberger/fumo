defmodule Fumo.Authorizer do
  alias Fumo.Accounts.User
  alias Fumo.FlashCards.Deck
  def can_manage?(%User{id: user_id}, %Deck{user_id: deck_user_id}) do
    user_id == deck_user_id
  end

  def can_manage?(user, resource) when is_nil(user) or is_nil(resource), do: false
end
