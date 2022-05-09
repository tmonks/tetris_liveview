defmodule Tetris.Point do
  def origin() do
    {0, 0}
  end

  def left({x, y}) do
    {x - 1, y}
  end

  def right({x, y}) do
    {x + 1, y}
  end

  def down({x, y}) do
    {x, y + 1}
  end

  def move({point_x, point_y}, {change_x, change_y}) do
    {point_x + change_x, point_y + change_y}
  end
end
