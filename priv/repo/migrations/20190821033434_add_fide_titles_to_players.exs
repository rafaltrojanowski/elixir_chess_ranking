defmodule SacSacMate.Repo.Migrations.AddFideTitlesToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :fide_title, :string
      add :fide_women_title, :string
    end
  end
end
