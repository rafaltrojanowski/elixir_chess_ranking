defmodule SacSacMate.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do

      add :standard_rating, :integer
      add :rapid_rating, :integer
      add :blitz_rating, :integer

      add :standard_games, :integer
      add :rapid_games, :integer
      add :blitz_games, :integer

      add :standard_k_factor, :integer
      add :rapid_k_factor, :integer
      add :blitz_k_factor, :integer

      add :fideid, :integer

      add :name, :string
      add :country, :string
      add :sex, :string

      add :fide_title, :string
      add :fide_women_title, :string

      add :birthyear, :integer

      add :date, :date

      # we do allow nulls as we use Repo.insert_all which does not support associations
      add :player_id, references(:players, null: true)

      timestamps()
    end

    create index(:ratings, [:player_id])
    create unique_index(:ratings, [:fideid, :date])
  end
end
