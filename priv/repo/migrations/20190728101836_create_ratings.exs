defmodule SacSacMate.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :standard_rating, :integer
      add :rapid_rating, :integer
      add :blitz_rating, :integer
      add :date, :date

      # we do allow nulls as we use Repo.insert_all which does not support associations
      add :player_id, references(:players)

      timestamps()
    end

  end
end
