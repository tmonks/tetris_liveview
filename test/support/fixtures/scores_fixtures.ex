defmodule Tetris.ScoresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Tetris.Scores` context.
  """

  @doc """
  Generate a score.
  """
  def score_fixture(attrs \\ %{}) do
    {:ok, score} =
      attrs
      |> Enum.into(%{
        player: "some player",
        value: 42
      })
      |> Tetris.Scores.create_score()

    score
  end
end
