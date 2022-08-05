defmodule SacSacMateWeb.Schema do
  use Absinthe.Schema

  alias SacSacMateWeb.PlayerResolver

  # query {
  #   allPlayers(page: 3) {
  #     results {
  #       fideid
  #       last_name
  #       country
  #     },
  #     meta {
  #       page,
  #       totalPages
  #     }
  #   }
  # }

  query do
    @desc "Get all players"
    field :all_players, :paginated_players do
      arg(:page, non_null(:integer))
      resolve(&PlayerResolver.all_players/3)
    end
  end

  @doc """
  Paginated posts object contains list of data and meta information
  """
  object :paginated_players do
    field :results, list_of(:player)
    field :meta, :page_info
  end

  @doc """
  Meta information object structure
  """
  object :page_info do
    field :page, :integer
    field :total_pages, :float
  end

  object :player do
    field :fideid, non_null(:integer)
    field :last_name, non_null(:string)
    field :country, non_null(:string)
  end

  mutation do
    @desc "Create a new player"
    field :create_player, :player do
      arg :fideid, non_null(:integer)
      arg :last_name, non_null(:string)
      arg :country, non_null(:string)

      resolve &PlayerResolver.create_player/3
    end
  end
end
