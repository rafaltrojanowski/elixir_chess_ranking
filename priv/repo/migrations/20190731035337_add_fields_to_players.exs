defmodule SacSacMate.Repo.Migrations.AddFieldsToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :sex, :string
      add :fideid, :string
    end
  end
end
