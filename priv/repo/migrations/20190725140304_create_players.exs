defmodule SacSacMate.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string
      add :country, :string
      add :date_of_birth, :string

      timestamps()
    end

  end
end
