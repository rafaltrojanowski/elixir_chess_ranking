defmodule SacSacMate.Player.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :standard_rating, :integer
    field :blitz_rating, :integer
    field :rapid_rating, :integer

    field :standard_games, :integer
    field :rapid_games, :integer
    field :blitz_games, :integer

    field :standard_k_factor, :integer
    field :rapid_k_factor, :integer
    field :blitz_k_factor, :integer

    field :fideid, :integer

    field :name, :string
    field :country, :string
    field :sex, :string

    field :birthyear, :integer

    field :date, :date

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
