defmodule TetrisWeb.GameLive.Welcome do
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
          <h1>Welcome to TetrisLive!</h1>
          <h2>Stack 'em up!</h2>
          <button phx-click="play">Play</button>
        </div>
      </section>
    """
  end

  defp play(socket) do
    push_redirect(socket, to: Routes.game_playing_path(socket, :playing))
  end

  def handle_event("play", __data, socket) do
    {:noreply, play(socket)}
  end
end
