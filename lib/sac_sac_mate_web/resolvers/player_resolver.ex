defmodule SacSacMateWeb.PlayerResolver do
  alias SacSacMate.Accounts

  @per_page 2

  # def all_players(_, %{page: page}, _) do
    # {:ok, Accounts.players(page, @per_page)}
  # end

  def create_player(_root, args, _info) do
    # TODO: add detailed error message handling later
    case Accounts.create_player(args) do
      {:ok, player} ->
        {:ok, player}
      _error ->
        {:error, "could not create player"}
    end
  end


  @doc """
  Returns custom data set to support graphql defined structure
  """
  def all_players(_, %{page: page}, _) do
    results = Accounts.players(page, @per_page)
    total_pages = Float.ceil(Accounts.count() / @per_page)

    {:ok, %{results: results, meta: %{page: page, total_pages: total_pages}}}
  end
end
