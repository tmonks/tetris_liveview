defmodule Tetris.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :integer
      add :player, :string

      timestamps()
    end
  end
end
