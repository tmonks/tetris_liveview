defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)

    {:ok,
     socket
     |> new_tetromino()
     |> show()}
  end

  def render(assigns) do
    ~H"""
      <% [{x, y}] = @points %>
      <section class="phx-hero">
        <pre>
          location: {<%= x %>, <%= y %>}
        </pre>
      </section>
    """
  end

  defp new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp show(socket) do
    assign(socket, points: Tetromino.points(socket.assigns.tetro))
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    socket
    |> assign(:tetro, Tetromino.down(tetro))
    |> show()
  end

  def handle_info(:tick, socket) do
    IO.puts("Tick!")
    {:noreply, socket |> down()}
  end
end
