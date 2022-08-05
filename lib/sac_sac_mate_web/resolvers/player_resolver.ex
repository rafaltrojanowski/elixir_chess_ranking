defmodule SacSacMateWeb.PlayerResolver do
  alias SacSacMate.Accounts

  @per_page 2

  def all_players(_, %{page: page}, _) do
    {:ok, Accounts.players(page, @per_page)}
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
