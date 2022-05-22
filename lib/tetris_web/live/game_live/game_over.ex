defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <h1>Game Over</h1>
      </section>
    """
  end
end
