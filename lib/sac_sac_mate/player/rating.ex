defmodule SacSacMate.Player.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :blitz_ranking, :integer
    field :date, :date
    field :rapid_ranking, :integer
    field :standard_rating, :integer

    belongs_to :player, SacSacMate.Accounts.Player

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:standard_rating, :rapid_ranking, :blitz_ranking, :date, :player_id])
    |> validate_required([:date, :player_id])
  end
end
