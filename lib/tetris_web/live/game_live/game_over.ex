defmodule TetrisWeb.GameLive.GameOver do
  use TetrisWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, assign(socket, score: params["score"])}
  end

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <div>
          <h1>Game Over!</h1>
          <h2>Your score: <%= @score %></h2>
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
