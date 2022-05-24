defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view
  alias Tetris.Game

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(socket, game: Map.get(socket.assigns, :game) || Game.new())
    }
  end

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <div>
          <h1>Game Over!</h1>
          <h2>Your score: <%= @game.score %></h2>
          <button phx-click="play">Play Again</button>
        </div>
      </section>
    """
  end

  defp play(socket) do
    push_redirect(socket, to: "/game/playing")
  end

  def handle_event("play", __data, socket) do
    {:noreply, play(socket)}
  end
end
