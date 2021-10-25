defmodule Fumo.AccountsHelper do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Fumo.Accounts` context.
  """

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.body, "[TOKEN]")
    token
  end
end
