defmodule TetrisWeb.GameLive do
  use TetrisWeb, :live_view
  alias Tetris.Game

  @rotate_keys ["ArrowDown", " "]

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(500, :tick)
    end

    {:ok, new_game(socket)}
  end

  def render(assigns) do
    ~H"""
      <section class="phx-hero">
        <div phx-window-keydown="keystroke">
          <h1>Welcome to Tetris</h1>
          <%= render_board(assigns) %>
          <pre>
            <%= inspect @game.tetro %>
          </pre>
        </div>
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
      <%= for {x, y, shape} <- @game.points do %>
        <rect
          width="20" height="20"
          x={(x-1) * 20} y={(y-1) * 20}
          style={"fill:#{color(shape)}"} />
      <% end %>
    """
  end

  defp color(:l), do: "orange"
  defp color(:j), do: "blue"
  defp color(:s), do: "limegreen"
  defp color(:z), do: "red"
  defp color(:o), do: "yellow"
  defp color(:i), do: "aqua"
  defp color(:t), do: "purple"
  defp color(_), do: "red"

  defp new_game(socket) do
    assign(socket, game: Game.new())
  end

  defp new_tetromino(socket) do
    assign(socket, game: Game.new_tetromino(socket.assigns.game))
  end

  def rotate(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.rotate(game))
  end

  def down(%{assigns: %{game: %{tetro: %{location: {_, 20}}}}} = socket) do
    socket
    |> new_tetromino()
  end

  def down(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.down(game))
  end

  def right(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.right(game))
  end

  def left(%{assigns: %{game: game}} = socket) do
    socket
    |> assign(:game, Game.left(game))
  end

  def handle_info(:tick, socket) do
    {:noreply, socket |> down()}
  end

  def handle_event("keystroke", %{"key" => key}, socket) when key in @rotate_keys do
    {:noreply, socket |> rotate()}
  end

  def handle_event("keystroke", %{"key" => "ArrowRight"}, socket) do
    {:noreply, socket |> right()}
  end

  def handle_event("keystroke", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, socket |> left()}
  end

  def handle_event("keystroke", _, socket) do
    {:noreply, socket}
  end
end
