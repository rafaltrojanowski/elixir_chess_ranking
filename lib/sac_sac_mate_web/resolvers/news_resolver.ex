defmodule SacSacMateWeb.NewsResolver do
  alias SacSacMate.Accounts

  def all_players(_root, _args, _info) do
    {:ok, Accounts.list_players()}
  end
end
