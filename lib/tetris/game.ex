defmodule Tetris.Game do
  defstruct [:tetro, score: 0, junkyard: %{}]

  alias Tetris.{Points, Tetromino}

  def move(game, move_fn) do
    old = game.tetro

    new =
      game.tetro
      |> move_fn.()

    valid =
      new
      |> Tetromino.show()
      |> Points.valid?()

    Tetromino.maybe_move(old, new, valid)
  end
end
