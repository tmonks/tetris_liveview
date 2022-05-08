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
      <% {x, y} = @tetro.location %>
      <section class="phx-hero">
        <h1>Welcome to Tetris</h1>
        <%= render_board(assigns) %>
        <pre>
          location: {<%= x %>, <%= y %>}
        </pre>
      </section>
    """
  end

  defp render_board(assigns) do
    ~H"""
    <svg width="200" height="400">
      <rect width="200" height="400" style="fill:rgb(0,0,0);" />
      <%= render_points(assigns) %>
    </svg>
    """
  end

  def render_points(assigns) do
    ~H"""
      <%= for {x, y} <- @points do %>
        <rect
          width="20" height="20"
          x={(x-1) * 20} y={(y-1) * 20}
          style="fill:rgb(255,0,0);" />
      <% end %>
    """
  end

  defp new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  defp show(socket) do
    assign(socket, points: Tetromino.points(socket.assigns.tetro))
  end

  def down(%{assigns: %{tetro: %{location: {_, 20}}}} = socket) do
    socket
    |> new_tetromino()
  end

  def down(%{assigns: %{tetro: tetro}} = socket) do
    socket
    |> assign(:tetro, Tetromino.down(tetro))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down() |> show()}
  end
end
