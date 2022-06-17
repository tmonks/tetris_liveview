defmodule Tetris.Scores.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :player, :string
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:value, :player])
    |> validate_required([:value, :player])
  end
end
