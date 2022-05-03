defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Tetromino

  def mount(_params, _session, socket) do
    :timer.send_interval(500, :tick)
    {:ok, socket |> new_tetromino}
  end

  def new_tetromino(socket) do
    assign(socket, tetro: Tetromino.new_random())
  end

  def render(assigns) do
    ~H"""
      <% {x, y} = @tetro.location %>
      <section class="phx-hero">
        <pre>
          shape: <%= @tetro.shape %>
          rotation: <%= @tetro.rotation %>
          location: {<%= x %>, <%= y %>}
        </pre>
      </section>
    """
  end

  # def down(socket) do
  def down(%{assigns: %{tetro: tetro}} = socket) do
    # %{tetro: tetro} = socket.assigns

    IO.inspect(tetro, label: "tetro")

    socket
    |> assign(:tetro, tetro |> Tetromino.down())
  end

  def handle_info(:tick, socket) do
    IO.puts("Tick!")
    {:noreply, socket |> down()}
  end
end
