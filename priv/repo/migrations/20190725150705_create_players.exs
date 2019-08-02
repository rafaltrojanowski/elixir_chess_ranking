defmodule SacSacMate.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :fideid, :string, null: false
      add :first_name, :string
      add :last_name, :string, null: false
      add :country, :string, null: false
      add :birthyear, :integer
      add :sex, :string

      timestamps()
    end

    create unique_index(:players, [:fideid])
  end
end
