defmodule SacSacMateWeb.Schema do
  use Absinthe.Schema

  alias SacSacMateWeb.PlayerResolver

  object :player do
    field :fideid, non_null(:integer)
    field :last_name, non_null(:string)
    field :country, non_null(:string)
  end

  query do
    @desc "Get all players"
    field :all_players, non_null(list_of(non_null(:player))) do
      resolve(&PlayerResolver.all_players/3)
    end
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
