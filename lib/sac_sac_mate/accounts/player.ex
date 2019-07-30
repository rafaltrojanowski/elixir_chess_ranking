defmodule SacSacMate.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :country, :string
    field :date_of_birth, :string
    field :first_name, :string
    field :last_name, :string

    has_many :ratings, SacSacMate.Player.Rating

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:first_name, :last_name, :country, :date_of_birth])
    |> validate_required([:first_name, :last_name, :country])
    |> unique_constraint(:fullname, name: :players_first_name_last_name_country_index)
  end
end
