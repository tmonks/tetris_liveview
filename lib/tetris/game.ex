defmodule Tetris.Game do
  defstruct [:tetro, points: [], score: 0, junkyard: %{}]

  alias Tetris.{Points, Tetromino}

  def new do
    __struct__()
    |> new_tetromino()
    |> show()
  end

  def move(game, move_fn) do
    {old, new, valid} = move_data(game, move_fn)

    moved = Tetromino.maybe_move(old, new, valid)

    %{game | tetro: moved}
    |> show()
  end

  def move_data(game, move_fn) do
    old_tetro = game.tetro

    new_tetro =
      game.tetro
      |> move_fn.()

    valid =
      new_tetro
      |> Tetromino.show()
      |> Points.valid?(game.junkyard)

    {old_tetro, new_tetro, valid}
  end

  def down(game) do
    {old_tetro, new_tetro, valid} = move_data(game, &Tetromino.down/1)

    move_down_or_merge(game, old_tetro, new_tetro, valid)
  end

  def move_down_or_merge(game, _old, new_tetro, true = _valid) do
    %{game | tetro: new_tetro}
    |> show()
    |> inc_score(1)
  end

  def move_down_or_merge(game, old_tetro, _new, false = _valid) do
    game
    |> merge(old_tetro)
    |> new_tetromino()
    |> show()
  end

  def merge(game, old_tetro) do
    new_junkyard =
      old_tetro
      |> Tetromino.show()
      |> Enum.map(fn {x, y, shape} -> {{x, y}, shape} end)
      |> Enum.into(game.junkyard)

    %{game | junkyard: new_junkyard}
  end

  def junkyard_points(game) do
    game.junkyard
    |> Enum.map(fn {{x, y}, shape} -> {x, y, shape} end)
  end

  def right(game), do: game |> move(&Tetromino.right/1) |> show()
  def left(game), do: game |> move(&Tetromino.left/1) |> show()
  def rotate(game), do: game |> move(&Tetromino.rotate/1) |> show()

  def new_tetromino(game) do
    %{game | tetro: Tetromino.new_random()}
    |> show()
  end

  def show(game) do
    %{game | points: Tetromino.show(game.tetro)}
  end

  def inc_score(game, value) do
    %{game | score: game.score + value}
  end
end
