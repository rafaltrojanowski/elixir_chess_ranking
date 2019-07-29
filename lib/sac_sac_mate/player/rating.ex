defmodule SacSacMate.Player.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :blitz_ranking, :integer
    field :date, :date
    field :player_id, :integer
    field :rapid_ranking, :integer
    field :standard_rating, :integer

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:standard_rating, :rapid_ranking, :blitz_ranking, :date, :player_id])
    # |> validate_required([:standard_rating, :rapid_ranking, :blitz_ranking, :date, :player_id])
  end
end
