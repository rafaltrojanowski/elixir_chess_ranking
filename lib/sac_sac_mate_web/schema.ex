defmodule SacSacMateWeb.Schema do
  use Absinthe.Schema

  alias SacSacMateWeb.NewsResolver

  object :player do
    field :fideid, non_null(:integer)
    field :last_name, non_null(:string)
    field :country, non_null(:string)
  end

  query do
    @desc "Get all players"
    field :all_players, non_null(list_of(non_null(:player))) do
      resolve(&NewsResolver.all_players/3)
    end
  end
end
