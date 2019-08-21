defmodule SacSacMate.Accounts.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :fideid, :integer

    field :first_name, :string
    field :last_name, :string

    field :sex, :string
    field :country, :string
    field :birthyear, :integer

    field :fide_title, :string
    field :fide_women_title, :string

    has_many :ratings, SacSacMate.Player.Rating

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [
      :fideid,
      :first_name,
      :last_name,
      :country,
      :birthyear,
      :sex,
      :fide_title,
      :fide_women_title
    ])
    |> validate_required([:fideid, :last_name, :country])
    |> unique_constraint(:fideid)
  end
end
