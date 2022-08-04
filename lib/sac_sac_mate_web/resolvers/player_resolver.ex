defmodule SacSacMateWeb.PlayerResolver do
  alias SacSacMate.Accounts

  def all_players(_root, _args, _info) do
    {:ok, Accounts.list_players()}
  end

  def create_player(_root, args, _info) do
    # TODO: add detailed error message handling later
    case Accounts.create_player(args) do
      {:ok, player} ->
        {:ok, player}
      _error ->
        {:error, "could not create player"}
    end
  end
end
