defmodule Tetris.Points do
  alias Tetris.Point

  def move(points, change) do
    points
    |> Enum.map(fn point -> Point.move(point, change) end)
  end

  def add_shape(points, shape) do
    points
    |> Enum.map(fn point -> Point.add_shape(point, shape) end)
  end

  def rotate(points, degrees) do
    points
    |> Enum.map(&Point.rotate(&1, degrees))
  end

  def valid?(points, junkyard) do
    Enum.all?(points, &Point.valid?(&1, junkyard))
  end
end
