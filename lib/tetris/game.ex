defmodule Tetris.Game do
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  alias Tetris.{Points, Tetromino}

  def new do
    __struct__()
    |> new_tetromino()
    |> show()
  end

  def move(game, move_fn) do
    old = game.tetro

    new =
      game.tetro
      |> move_fn.()

    valid =
      new
      |> Tetromino.show()
      |> Points.valid?()

    moved = Tetromino.maybe_move(old, new, valid)

    %{game | tetro: moved}
    |> show()
  end

  def right(game), do: game |> move(&Tetromino.right/1) |> show()
  def left(game), do: game |> move(&Tetromino.left/1) |> show()
  def rotate(game), do: game |> move(&Tetromino.rotate/1) |> show()
  def down(game), do: game |> move(&Tetromino.down/1) |> show()

  def new_tetromino(game) do
    %{game | tetro: Tetromino.new_random()}
    |> show()
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end
end
