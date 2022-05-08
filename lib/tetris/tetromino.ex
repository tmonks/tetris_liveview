defmodule Tetris.Tetromino do
  defstruct shape: :l, rotation: 0, location: {5, 1}

  alias Tetris.Point

  def new(options \\ []) do
    __struct__(options)
  end

  def new_random do
    new(shape: random_shape())
  end

  def right(tetro) do
    %{tetro | location: Point.right(tetro.location)}
  end

  def left(tetro) do
    %{tetro | location: Point.left(tetro.location)}
  end

  def down(tetro) do
    %{tetro | location: Point.down(tetro.location)}
  end

  def rotate(tetro) do
    %{tetro | rotation: rotate_degrees(tetro.rotation)}
  end

  def points(%{location: {x, y}} = _tetro) do
    [
      {x + 1, y},
      {x + 1, y + 1},
      {x + 1, y + 2},
      {x + 2, y + 2}
    ]
  end

  defp random_shape do
    ~w[i t o l j z s]a
    |> Enum.random()
  end

  defp rotate_degrees(270), do: 0
  defp rotate_degrees(n), do: n + 90
end
