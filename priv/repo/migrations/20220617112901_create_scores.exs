defmodule Tetris.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :value, :integer
      add :player, :string

      timestamps()
    end
  end
end
