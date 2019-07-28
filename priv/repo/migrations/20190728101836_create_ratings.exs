defmodule SacSacMate.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :standard_rating, :integer
      add :rapid_ranking, :integer
      add :blitz_ranking, :integer
      add :date, :date
      add :player_id, references(:players), null: false

      timestamps()
    end

  end
end
