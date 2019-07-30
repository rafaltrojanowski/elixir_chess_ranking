defmodule SacSacMate.Player.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :blitz_rating, :integer
    field :date, :date
    field :rapid_rating, :integer
    field :standard_rating, :integer

    belongs_to :player, SacSacMate.Accounts.Player

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:standard_rating, :rapid_rating, :blitz_rating, :date, :player_id])
    |> validate_required([:date, :player_id])
  end
end
